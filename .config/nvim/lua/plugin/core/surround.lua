vim.g.nvim_surround_no_mappings = true
local u = require('utils')
u.gh('kylechui/nvim-surround')
require('nvim-surround').setup({
  surrounds = {
    [')'] = { change = { target = '^(. ?)().-( ?.)()$' } },
    ['}'] = { change = { target = '^(. ?)().-( ?.)()$' } },
    ['>'] = { change = { target = '^(. ?)().-( ?.)()$' } },
    [']'] = { change = { target = '^(. ?)().-( ?.)()$' } },
  },
  aliases = {
    a = '>', -- angle
    b = ')',
    B = '}',
    r = ']',
    q = false,
  },
  move_cursor = 'sticky',
})
