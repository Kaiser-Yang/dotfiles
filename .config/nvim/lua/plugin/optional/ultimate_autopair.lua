local u = require('utils')
u.gh('altermo/ultimate-autopair.nvim')

require('ultimate-autopair.core').modes = {}
require('ultimate-autopair').setup({
  tabout = { enable = true, hopout = true },
  fastwarp = { nocursormove = false },
  bs = { delete_from_end = false },
})
