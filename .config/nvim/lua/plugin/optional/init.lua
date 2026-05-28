require('plugin.optional.colorscheme')
vim.schedule(function()
  -- Competitive programming test runner
  require('plugin.optional.competitest')
  -- Database client (vim-dadbod)
  require('plugin.optional.dadbod')
  -- Debug Adapter Protocol (DAP) integration
  require('plugin.optional.dap')
  -- Winbar breadcrumbs
  require('plugin.optional.dropbar')
  -- LSP status UI
  require('plugin.optional.fidget')
  -- Code action indicator
  require('plugin.optional.lightbulb')
  -- Markdown viewer
  require('plugin.optional.render_markdown')
  -- Easy window resizing
  require('plugin.optional.win_resizer')
end)
