local u = require('utils')
u.gh('j-hui/fidget.nvim')
require('fidget').setup({ notification = { window = { winblend = 0 } } })
