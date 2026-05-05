local u = require('utils')
vim.pack.add({
  u.gh('nvim-tree/nvim-web-devicons'),
  u.gh('nvim-lualine/lualine.nvim'),
}, { confirm = false })

require('lualine').setup({
  options = {
    globalstatus = true,
    always_divide_middle = true,
  },
  sections = {
    lualine_c = { 'filename', 'filesize' },
    lualine_x = { 'searchcount', 'lsp_status', 'encoding', 'fileformat', 'filetype' },
  },
})
