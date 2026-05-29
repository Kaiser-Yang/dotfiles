require('plugin.optional.colorscheme')
vim.schedule(function()
  -- Competitive programming test runner
  require('plugin.optional.competitest')
  -- Database client (vim-dadbod)
  require('plugin.optional.dadbod')
  -- Winbar breadcrumbs
  require('plugin.optional.dropbar')
  -- LSP status UI
  require('plugin.optional.fidget')
  -- Code action indicator
  require('plugin.optional.lightbulb')
  -- Markdown viewer
  require('plugin.optional.render_markdown')
  -- Better UI for vim.ui.input / vim.ui.select
  require('plugin.optional.nui')
  -- Easy window resizing
  require('plugin.optional.win_resizer')
end)
