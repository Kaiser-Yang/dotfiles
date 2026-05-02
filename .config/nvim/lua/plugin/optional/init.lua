vim.schedule(function()
  -- highlight pairs
  require('plugin.optional.blink_pairs')
  -- competition test tool
  require('plugin.optional.competitest')
  -- dadbod works as a database client
  require('plugin.optional.dadbod')
  -- DAP for debugging
  require('plugin.optional.dap')
  -- auto insert "end" for some languages
  require('plugin.optional.endwise')
  -- pairs plugin
  require('plugin.optional.ultimate_autopair')
  -- easy way to resize windows
  require('plugin.optional.win_resizer')
end)
