local u = require('utils')
vim.pack.add({ u.gh('altermo/ultimate-autopair.nvim') }, { confirm = false })

require('ultimate-autopair.core').modes = {}
require('ultimate-autopair').setup({
  tabout = { enable = true, hopout = true },
  fastwarp = { nocursormove = false },
  bs = { delete_from_end = false },
})
