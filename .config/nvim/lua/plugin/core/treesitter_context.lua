local u = require('utils')

require('treesitter-context').setup({
  max_liens = math.max(vim.o.scrolloff, 5),
  on_attach = function(buffer) return not u.buffer.big(buffer) end,
})
