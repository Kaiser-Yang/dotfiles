local u = require('utils')
u.gh('rmagatti/auto-session')

require('auto-session').setup({
  auto_save = vim.fs.root(0, '.git'),
  auto_create = vim.fs.root(0, '.git'),
  auto_restore = vim.fs.root(0, '.git'),
  session_lens = { mappings = false },
})
