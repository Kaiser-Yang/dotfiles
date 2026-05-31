local u = require('utils')
u.gh('tronikelis/ts-autotag.nvim')
require('ts-autotag').setup({
  auto_rename = { enabled = true },
  should_attach = function(buf) return not vim.b[buf].pairs end,
})
