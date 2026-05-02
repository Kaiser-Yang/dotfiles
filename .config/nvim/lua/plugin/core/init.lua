vim.schedule(function()
  -- blink for completion
  require('plugin.core.blink_cmp')
  -- indent line
  require('plugin.core.blink_indent')
  -- formatter
  require('plugin.core.conform')
  -- git status for buffers
  require('plugin.core.gitsigns')
  -- guess indent style for buffers
  require('plugin.core.guess_indent')
  -- beautiful status line
  require('plugin.core.lualine')
  -- global key mappings manager
  require('plugin.core.maplayer')
  -- better vim.ui.input and vim.ui.select
  require('plugin.core.nui')
  -- file explorer
  require('plugin.core.nvim_tree')
  -- ";" and "," can be used to repeat last motion
  require('plugin.core.repmove')
  -- git conflicts resolver
  require('plugin.core.resolve')
  -- add, delete, and change pairs
  require('plugin.core.surround')
  -- telescope for pickers
  require('plugin.core.telescope')
  -- highlight the "TODO" comments
  require('plugin.core.todo_comments')
  -- treesitter installer
  require('plugin.core.treesitter')
  -- treesitter context window
  require('plugin.core.treesitter_context')
  -- treesitter based motion and swap
  require('plugin.core.treesitter_textobjects')
  -- show key mappings as you type
  require('plugin.core.which_key')
end)
