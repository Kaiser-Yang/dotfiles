vim.schedule(function()
  local u = require('utils')
  local specs = {
    -- deps
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
    -- blink for completion
    'Kaiser-Yang/blink-cmp-dictionary',
    'saghen/blink.lib',
    'saghen/blink.cmp',
    -- telescope for pickers
    'nvim-telescope/telescope-live-grep-args.nvim',
    'nvim-telescope/telescope-fzf-native.nvim',
    'nvim-telescope/telescope.nvim',
    'kkharji/sqlite.lua',
    'prochri/telescope-all-recent.nvim',
    -- git status for buffers
    'lewis6991/gitsigns.nvim',
    -- git conflicts resolver
    'Kaiser-Yang/resolve.nvim',
    -- treesitter installer
    { 'nvim-treesitter/nvim-treesitter', 'main' },
    -- treesitter context window
    'nvim-treesitter/nvim-treesitter-context',
    -- treesitter based motion and swap
    { 'nvim-treesitter/nvim-treesitter-textobjects', 'main' },
    -- formatter
    'stevearc/conform.nvim',
    -- file explorer
    'nvim-tree/nvim-tree.lua',
    -- add, delete, and change pairs
    'kylechui/nvim-surround',
    -- auto guess indent style for buffers
    'NMAC427/guess-indent.nvim',
    -- ";" and "," can be used to repeat last motion
    'Kaiser-Yang/repmove.nvim',
    -- global key mappings manager
    'Kaiser-Yang/maplayer.nvim',
    -- show key mappings as you type
    'Kaiser-Yang/which-key.nvim',
    -- beautiful status line
    'nvim-lualine/lualine.nvim',
    -- highlight the "TODO" comments
    'folke/todo-comments.nvim',
    -- indent line
    'saghen/blink.indent',
  }
  for i = 1, #specs do
    if type(specs[i]) == 'table' then
      ---@diagnostic disable-next-line: assign-type-mismatch, param-type-mismatch
      specs[i] = u.gh(unpack(specs[i]))
    else
      ---@diagnostic disable-next-line: assign-type-mismatch
      specs[i] = u.gh(specs[i])
    end
  end
  vim.pack.add(specs, { confirm = false })
  require('plugin.core.blink_cmp')
  require('plugin.core.blink_indent')
  require('plugin.core.conform')
  require('plugin.core.gitsigns')
  require('plugin.core.guess_indent')
  require('plugin.core.lualine')
  require('plugin.core.maplayer')
  require('plugin.core.nui')
  require('plugin.core.nvim_tree')
  require('plugin.core.resolve')
  require('plugin.core.surround')
  require('plugin.core.telescope')
  require('plugin.core.todo_comments')
  require('plugin.core.treesitter')
  require('plugin.core.treesitter_context')
  require('plugin.core.treesitter_textobjects')
  require('plugin.core.which_key')
end)
