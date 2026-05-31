local u = require('utils')
u.gh('tronikelis/ts-autotag.nvim')
require('ts-autotag').setup({ auto_rename = { enabled = true } })
