local u = require('utils')
u.gh('brenoprata10/nvim-highlight-colors')
require('nvim-highlight-colors').setup({
  exclude_buffer = function(bufnr) return vim.b[bufnr].color == false or vim.g.color == false end,
})
