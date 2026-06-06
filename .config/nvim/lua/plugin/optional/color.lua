local u = require('utils')
u.gh('brenoprata10/nvim-highlight-colors')
require('nvim-highlight-colors').setup({
  exclude_buffer = function(buf) return not u.enabled('color', buf) end,
})
