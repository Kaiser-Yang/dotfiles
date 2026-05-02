local u = require('utils')
vim.pack.add({ u.gh('Kaiser-Yang/win-resizer.nvim') }, { confirm = false })

require('win-resizer').setup({ ignore_filetypes = { 'neo-tree', 'NvimTree', 'Avante', 'AvanteInput' } })
