vim.g.nvim_surround_no_mappings = true
require('nvim-surround').setup({
  surrounds = {
    [')'] = { change = { target = '^(. ?)().-( ?.)()$' } },
    ['}'] = { change = { target = '^(. ?)().-( ?.)()$' } },
    ['>'] = { change = { target = '^(. ?)().-( ?.)()$' } },
    [']'] = { change = { target = '^(. ?)().-( ?.)()$' } },
  },
  move_cursor = 'sticky',
})
