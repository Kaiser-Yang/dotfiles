vim.keymap.set({ 'c' }, '<m-p>', '<up>', { noremap = true, silent = false })
vim.keymap.set({ 'c' }, '<m-n>', '<down>', { noremap = true, silent = false })
vim.keymap.set({ 'c' }, '<m-b>', '<s-left>', { noremap = true, silent = false })
vim.keymap.set({ 'c' }, '<m-f>', '<s-right>', { noremap = true, silent = false })
vim.keymap.set({ 'c' }, '<c-b>', '<left>', { noremap = true, silent = false })
vim.keymap.set({ 'c' }, '<c-f>', '<right>', { noremap = true, silent = false })
vim.keymap.set({ 'i' }, '<c-h>', '<bs>', { remap = true })
for _, ch in pairs({ '0', '^', '$' }) do
  vim.keymap.set({ 'n', 'x', 'v' }, ch, function()
    if vim.v.virtnum ~= 0 then
      return 'g' .. ch
    else
      return ch
    end
  end, { expr = true, silent = true, noremap = true })
end
local function clear_hlsearch()
  local v = vim.o.hlsearch
  vim.o.hlsearch = false
  return vim.schedule_wrap(function() vim.o.hlsearch = v end)
end
vim.keymap.set('n', ']]', function()
  clear_hlsearch()()
  return 'j0[[%/{<CR>'
end, { expr = true, silent = true, remap = true, desc = 'Jump to next section or {' })
vim.keymap.set('n', '[[', function()
  clear_hlsearch()()
  return '?{<CR>w99[{'
end, { expr = true, silent = true, desc = 'Jump to previous section or {' })
vim.keymap.set('n', '][', function()
  clear_hlsearch()()
  return '/}<CR>b99]}'
end, { expr = true, silent = true, desc = 'Jump to next section or }' })
vim.keymap.set('n', '[]', function()
  clear_hlsearch()()
  return 'k$][%?}<CR>'
end, { expr = true, silent = true, remap = true, desc = 'Jump to previous section or }' })
