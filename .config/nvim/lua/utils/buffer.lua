local M = {}

function M.big(buffer, event)
  buffer = M.normalize_buf(buffer)
  local _size = M.buffer_size(buffer)
  local line_count = vim.api.nvim_buf_line_count(0)
  local limit = type(vim.b[buffer].big_file_limit) == 'number' and vim.b[buffer].big_file_limit
    or type(vim.g.big_file_limit) == 'number' and vim.g.big_file_limit
  local average_every_line = type(vim.b[buffer].big_file_average_every_line) == 'number'
      and vim.b[buffer].big_file_average_every_line
    or type(vim.g.big_file_average_every_line) == 'number' and vim.g.big_file_average_every_line
  -- We can not get the right line count before the buffer is loaded,
  -- so we can only check the file size in that case.
  if event == 'BufReadPre' then average_every_line = nil end
  return type(limit) == 'number' and _size >= limit
    or type(average_every_line) == 'number' and _size >= average_every_line * line_count
end

--- Normalize the buffer number to its real buffer identity.
function M.normalize_buf(buf)
  buf = buf or 0
  if buf == 0 then buf = vim.api.nvim_get_current_buf() end
  return buf
end

--- Return the size of the buffer in bytes.
--- @param buffer? integer The buffer number, defaults to the current buffer.
--- @return integer
function M.buffer_size(buffer)
  buffer = M.normalize_buf(buffer)
  local file_name = vim.api.nvim_buf_get_name(buffer)
  local res
  -- We should always try the file size first,
  -- because when in "BufReadPre" event, we can not get the offset correctly
  if not vim.bo[buffer].modified then
    res = vim.fn.getfsize(file_name)
    if res >= 0 then return res end
  end
  res = vim.api.nvim_buf_get_offset(buffer, vim.api.nvim_buf_line_count(buffer) - 1)
  -- Add size of the last line
  res = res + #(vim.api.nvim_buf_get_lines(buffer, -2, -1, false)[1] or '')
  return res
end

function M.normal(bufnr)
  bufnr = M.normalize_buf(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr)
    and vim.api.nvim_buf_is_loaded(bufnr)
    and vim.api.nvim_buf_get_name(bufnr) ~= ''
    and vim.bo[bufnr].buftype == ''
    and vim.bo[bufnr].modifiable
    and not vim.bo[bufnr].readonly
end

return M
