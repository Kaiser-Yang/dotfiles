local u = require('utils')
u.gh('lewis6991/gitsigns.nvim')

require('gitsigns').setup({
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = { delay = vim.o.updatetime },
  preview_config = { border = vim.o.winborder or nil },
})
