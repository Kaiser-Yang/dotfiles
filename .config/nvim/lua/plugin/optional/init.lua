-- Colorscheme
require('plugin.optional.colorscheme')
vim.schedule(function()
  -- Auto tag
  require('plugin.optional.autotag')
  -- Indent guides (indent lines)
  require('plugin.optional.blink_indent')
  -- Color Highlight
  require('plugin.optional.color')
  -- Competitive programming test runner
  require('plugin.optional.competitest')
  -- Database client (vim-dadbod)
  require('plugin.optional.dadbod')
  -- Winbar breadcrumbs
  require('plugin.optional.dropbar')
  -- Auto-insert `end` for some languages
  require('plugin.optional.endwise')
  -- LSP status UI
  require('plugin.optional.fidget')
  -- Find And Replace
  require('plugin.optional.grug_far')
  -- Code action indicator
  require('plugin.optional.lightbulb')
  -- Statusline
  require('plugin.optional.lualine')
  -- Better UI for vim.ui.input / vim.ui.select
  require('plugin.optional.nui')
  -- Markdown viewer
  require('plugin.optional.render_markdown')
  -- Tabline
  require('plugin.optional.tabby')
  -- Highlight and manage TODO/FIXME comments
  require('plugin.optional.todo_comments')
  -- Treesitter (parser installer)
  require('plugin.optional.treesitter')
  -- Treesitter context window
  require('plugin.optional.treesitter_context')
  -- Treesitter textobjects (motions / swap / select)
  require('plugin.optional.treesitter_textobjects')
  -- Show keybindings as you type (which-key)
  require('plugin.optional.which_key')
  -- Easy window resizing
  require('plugin.optional.win_resizer')
end)
