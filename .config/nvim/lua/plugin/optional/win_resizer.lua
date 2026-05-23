local u = require('utils')
u.gh('Kaiser-Yang/win-resizer.nvim')

require('win-resizer').setup({ ignore_filetypes = { 'neo-tree', 'NvimTree', 'Avante', 'AvanteInput' } })
