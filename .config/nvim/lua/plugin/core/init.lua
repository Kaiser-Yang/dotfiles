-- Session
require('plugin.core.session')
vim.schedule(function()
  -- Completion engine (blink)
  require('plugin.core.blink_cmp')
  -- Indent guides (indent lines)
  require('plugin.core.blink_indent')
  -- Highlight matching pairs (brackets/quotes, etc.)
  require('plugin.core.blink_pairs')
  -- Code formatter
  require('plugin.core.conform')
  -- Auto-insert `end` for some languages
  require('plugin.core.endwise')
  -- Git signs in the gutter + hunk actions (per buffer)
  require('plugin.core.gitsigns')
  -- Detect/guess indentation style per buffer
  require('plugin.core.guess_indent')
  -- Lint
  require('plugin.core.lint')
  -- Statusline
  require('plugin.core.lualine')
  -- Global keymaps manager / layer system
  require('plugin.core.maplayer')
  -- Better UI for vim.ui.input / vim.ui.select
  require('plugin.core.nui')
  -- File explorer
  require('plugin.core.nvim_tree')
  -- Repeat last motion with `;` and `,`
  require('plugin.core.repmove')
  -- Git conflict resolver
  require('plugin.core.resolve')
  -- Add/delete/change surrounding pairs
  require('plugin.core.surround')
  -- Fuzzy finder / pickers (Telescope)
  require('plugin.core.telescope')
  -- Highlight and manage TODO/FIXME comments
  require('plugin.core.todo_comments')
  -- Treesitter (parser installer)
  require('plugin.core.treesitter')
  -- Treesitter context window
  require('plugin.core.treesitter_context')
  -- Treesitter textobjects (motions / swap / select)
  require('plugin.core.treesitter_textobjects')
  -- Auto pairs plugin
  require('plugin.core.ultimate_autopair')
  -- Show keybindings as you type (which-key)
  require('plugin.core.which_key')
end)
