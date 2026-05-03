vim.schedule(function()
  -- Highlight matching pairs (brackets/quotes, etc.)
  require('plugin.optional.blink_pairs')
  -- Competitive programming test runner
  require('plugin.optional.competitest')
  -- Database client (vim-dadbod)
  require('plugin.optional.dadbod')
  -- Debug Adapter Protocol (DAP) integration
  require('plugin.optional.dap')
  -- Auto-insert `end` for some languages
  require('plugin.optional.endwise')
  -- Auto pairs plugin
  require('plugin.optional.ultimate_autopair')
  -- Easy window resizing
  require('plugin.optional.win_resizer')
end)
