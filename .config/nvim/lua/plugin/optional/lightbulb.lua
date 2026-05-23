local u = require('utils')
u.gh('kosayoda/nvim-lightbulb')
require('nvim-lightbulb').setup({
  autocmd = { enabled = false, updatetime = -1 },
  sign = { enabled = true },
  number = { enabled = true },
})
