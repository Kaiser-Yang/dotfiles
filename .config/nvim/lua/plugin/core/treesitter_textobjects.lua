local u = require('utils')
vim.pack.add({ u.gh('nvim-treesitter/nvim-treesitter-textobjects', 'main') }, { confirm = false })

require('nvim-treesitter-textobjects').setup()
