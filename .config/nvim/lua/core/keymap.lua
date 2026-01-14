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
