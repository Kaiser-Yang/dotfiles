local u = require('utils')
vim.pack.add({
  u.gh('nvim-tree/nvim-web-devicons'),
  u.gh('stevearc/aerial.nvim'),
}, { confirm = false })
require('aerial').setup({
  layout = {
    win_opts = { number = true, relativenumber = true, signcolumn = 'no', statuscolumn = '%l ' },
    default_direction = 'prefer_left',
    placement = 'window',
    resize_to_content = false,
    preserve_equality = true,
  },
  attach_mode = 'global',
})
