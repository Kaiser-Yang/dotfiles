vim.schedule(function()
  -- Outline
  require('plugin.optional.aerial')
  -- Highlight matching pairs (brackets/quotes, etc.)
  require('plugin.optional.blink_pairs')
  -- Competitive programming test runner
  require('plugin.optional.competitest')
  -- Database client (vim-dadbod)
  require('plugin.optional.dadbod')
  -- Debug Adapter Protocol (DAP) integration
  require('plugin.optional.dap')
  -- Winbar breadcrumbs
  require('plugin.optional.dropbar')
  -- Auto-insert `end` for some languages
  require('plugin.optional.endwise')
  -- LSP status UI
  require('plugin.optional.fidget')
  -- Code action indicator
  require('plugin.optional.lightbulb')
  -- Markdown viewer
  require('plugin.optional.render_markdown')
  -- Auto pairs plugin
  require('plugin.optional.ultimate_autopair')
  -- Easy window resizing
  require('plugin.optional.win_resizer')
end)
