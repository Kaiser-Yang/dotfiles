local u = require('utils')
u.gh('nvim-lua/plenary.nvim')
u.gh('nvim-telescope/telescope.nvim')
u.gh('Kaiser-Yang/auto-session')

-- HACK:
-- https://github.com/rmagatti/auto-session/issues/407
-- session now will clear jumplist
require('auto-session').setup({
  auto_save = vim.fs.root(0, '.git'),
  auto_create = vim.fs.root(0, '.git'),
  auto_restore = false,
  session_lens = {
    picker = 'telescope',
    mappings = {
      delete_session = false,
      alternate_session = false,
      copy_session = false,
      source_session = { { 'i', 'n' }, '<cr>' },
    },
  },
})
