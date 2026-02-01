local util = require('util')
util.key.set({ 'c' }, '<m-p>', '<up>', { silent = false })
util.key.set({ 'c' }, '<m-n>', '<down>', { silent = false })
util.key.set({ 'c' }, '<m-b>', '<s-left>', { silent = false })
util.key.set({ 'c' }, '<m-f>', '<s-right>', { silent = false })
util.key.set({ 'c' }, '<c-b>', '<left>', { silent = false })
util.key.set({ 'c' }, '<c-f>', '<right>', { silent = false })
util.key.set({ 'i' }, '<c-h>', '<bs>', { remap = true })
local function clear_hlsearch()
  local v = vim.o.hlsearch
  vim.o.hlsearch = false
  return vim.schedule_wrap(function() vim.o.hlsearch = v end)
end
util.key.set('n', ']]', function()
  clear_hlsearch()()
  return 'j0[[%/{<CR>'
end, { expr = true, remap = true, desc = 'Jump to next section or {' })
util.key.set('n', '[[', function()
  clear_hlsearch()()
  return '?{<CR>w99[{'
end, { expr = true, desc = 'Jump to previous section or {' })
util.key.set('n', '][', function()
  clear_hlsearch()()
  return '/}<CR>b99]}'
end, { expr = true, desc = 'Jump to next section or }' })
util.key.set('n', '[]', function()
  clear_hlsearch()()
  return 'k$][%?}<CR>'
end, { expr = true, remap = true, desc = 'Jump to previous section or }' })
util.key.set('n', '&', '<cmd>&&<cr>')
util.key.set('i', '<tab>', function()
  local lnum, col = unpack(vim.api.nvim_win_get_cursor(0))
  local content_before_cursor = vim.api.nvim_get_current_line():sub(1, col)
  if not content_before_cursor:match('^%s*$') or lnum == 1 then return '<tab>' end
  local last_line_indent = vim.fn.indent(vim.fn.line('.') - 1)
  local current_line_indent = vim.fn.indent(vim.fn.line('.'))
  if last_line_indent > current_line_indent then
    return '<c-f>'
  else
    return '<tab>'
  end
end, { expr = true })
