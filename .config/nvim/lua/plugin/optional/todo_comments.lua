local u = require('utils')
u.gh('nvim-lua/plenary.nvim')
u.gh('folke/todo-comments.nvim')

require('todo-comments').setup({ signs = false, highlight = { multiline = false, after = '' } })
