local util = require('util')
util.key.set({ 'c' }, '<m-p>', '<up>', { silent = false })
util.key.set({ 'c' }, '<m-n>', '<down>', { silent = false })
util.key.set({ 'c' }, '<m-b>', '<s-left>', { silent = false })
util.key.set({ 'c' }, '<m-f>', '<s-right>', { silent = false })
util.key.set({ 'c' }, '<c-b>', '<left>', { silent = false })
util.key.set({ 'c' }, '<c-f>', '<right>', { silent = false })
util.key.set({ 'i' }, '<c-h>', '<bs>', { remap = true })
for _, ch in pairs({ '0', '^', '$' }) do
  util.key.set({ 'n', 'x', 'v' }, ch, function()
    if vim.v.virtnum ~= 0 then
      return 'g' .. ch
    else
      return ch
    end
  end, { expr = true })
end
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
util.key.set('i', ',t', function()
  if util.inside_block({ 'comment' }) ~= true then
    vim.notify('Not inside comment block')
    return ',t'
  end
  return '<c-g>u``<++>' .. string.rep('<left>', 5)
end, { expr = true })
util.key.set('i', ',f', function()
  local pattern = '<++>'
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local cur_buf = vim.api.nvim_get_current_buf()
  local row_end = math.min(row + 100, vim.api.nvim_buf_line_count(cur_buf))
  local match = vim.fn.matchbufline(cur_buf, pattern, row, row_end)[1]
  if match then
    vim.api.nvim_win_set_cursor(0, { match.lnum, match.byteidx })
    util.key.feedkeys('<c-g>u' .. string.rep('<del>', #pattern), 'n')
  end
end)
