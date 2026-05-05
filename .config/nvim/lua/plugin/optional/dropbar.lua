local u = require('utils')
vim.pack.add({
  u.gh('nvim-telescope/telescope-fzf-native.nvim'),
  u.gh('Bekaboo/dropbar.nvim'),
}, { confirm = false })
require('dropbar').setup({})
