local u = require('utils')
vim.pack.add({
  u.gh('nvim-lua/plenary.nvim'),
  u.gh('folke/todo-comments.nvim'),
}, { confirm = false })

require('todo-comments').setup({ sign_priority = 1 })
