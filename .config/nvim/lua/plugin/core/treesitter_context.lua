local u = require('utils')
vim.pack.add({ u.gh('nvim-treesitter/nvim-treesitter-context') }, { confirm = false })

require('treesitter-context').setup({
  max_liens = math.max(vim.o.scrolloff, 5),
  on_attach = function(buffer) return not u.buffer.big(buffer) end,
})
