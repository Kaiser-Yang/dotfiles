local u = require('utils')
u.gh('rmagatti/auto-session')

-- HACK:
-- https://github.com/rmagatti/auto-session/issues/407
-- session now will clear jumplist
require('auto-session').setup({
  auto_save = vim.fs.root(0, '.git'),
  auto_create = vim.fs.root(0, '.git'),
  auto_restore = vim.fs.root(0, '.git'),
  session_lens = { mappings = false },
  close_filetypes_on_save = { 'help', 'man', 'grug-far', 'NvimTree', 'dap-view', 'CompetiTest' },
})
