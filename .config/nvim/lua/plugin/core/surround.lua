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
    s = ']', -- square
    q = { '"', "'", '`' },
    r = false,
  },
  move_cursor = 'sticky',
})
