local u = require('utils')
vim.pack.add({ u.gh('j-hui/fidget.nvim') }, { confirm = false })
require('fidget').setup({})
