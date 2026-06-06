local u = require('utils')
u.gh('nvim-treesitter/nvim-treesitter-context')

require('treesitter-context').setup({ max_lines = math.max(vim.o.scrolloff, 5) })
