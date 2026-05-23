local u = require('utils')
u.gh('nvim-treesitter/nvim-treesitter-context')

require('treesitter-context').setup({
  max_lines = math.max(vim.o.scrolloff, 5),
  on_attach = function(buffer) return not u.buffer.big(buffer) end,
})
