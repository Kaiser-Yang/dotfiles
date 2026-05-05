local u = require('utils')
vim.pack.add({
  u.gh('kosayoda/nvim-lightbulb'),
}, { confirm = false })
require('nvim-lightbulb').setup({
  autocmd = { enabled = false, updatetime = -1 },
  sign = { enabled = true },
  number = { enabled = true },
})
