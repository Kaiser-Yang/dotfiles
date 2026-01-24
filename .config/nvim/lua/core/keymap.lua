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
