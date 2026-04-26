vim.schedule(function()
  local u = require('utils')
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind
      if name == 'telescope-fzf-native.nvim' then
        vim.system({ 'make' }, { cwd = ev.data.path })
      elseif name == 'nvim-treesitter' and kind == 'update' then
        vim.cmd('TSUpdate')
      end
    end,
  })
  vim.pack.add({
    -- deps
    u.gh('nvim-lua/plenary.nvim'),
    u.gh('MunifTanjim/nui.nvim'),
    u.gh('nvim-tree/nvim-web-devicons'),

    -- blink
    u.gh('Kaiser-Yang/blink-cmp-dictionary'),
    u.gh('rafamadriz/friendly-snippets'),
    u.gh('saghen/blink.lib'),
    u.gh('saghen/blink.cmp'),

    -- pairs
    u.gh('kylechui/nvim-surround'),
    u.gh('RRethy/nvim-treesitter-endwise'),
    u.gh('saghen/blink.download'),
    u.gh('saghen/blink.pairs', vim.version.range('*')),
    u.gh('altermo/ultimate-autopair.nvim'),

    -- telescope
    u.gh('nvim-telescope/telescope-live-grep-args.nvim'),
    u.gh('nvim-telescope/telescope-fzf-native.nvim'),
    u.gh('nvim-telescope/telescope.nvim'),
    u.gh('kkharji/sqlite.lua'),
    u.gh('prochri/telescope-all-recent.nvim'),

    -- dadbod
    u.gh('tpope/vim-dadbod'),
    u.gh('kristijanhusak/vim-dadbod-completion'),
    u.gh('kristijanhusak/vim-dadbod-ui'),

    -- git
    u.gh('lewis6991/gitsigns.nvim'),
    u.gh('Kaiser-Yang/resolve.nvim'),

    -- treesitter
    u.gh('nvim-treesitter/nvim-treesitter-context'),
    u.gh('nvim-treesitter/nvim-treesitter', 'main'),
    u.gh('nvim-treesitter/nvim-treesitter-textobjects', 'main'),

    -- DAP
    u.gh('igorlfs/nvim-dap-view'),
    u.gh('theHamsta/nvim-dap-virtual-text'),
    u.gh('mfussenegger/nvim-dap'),

    u.gh('NMAC427/guess-indent.nvim'),
    u.gh('xeluxee/competitest.nvim'),
    u.gh('Kaiser-Yang/win-resizer.nvim'),
    u.gh('stevearc/conform.nvim'),
    u.gh('nvim-tree/nvim-tree.lua'),
    u.gh('Kaiser-Yang/repmove.nvim'),
    u.gh('Kaiser-Yang/maplayer.nvim'),

    u.gh('nvim-lualine/lualine.nvim'),
    u.gh('Kaiser-Yang/which-key.nvim'),
    u.gh('folke/todo-comments.nvim'),
    u.gh('saghen/blink.indent'),
    u.gh('neovim/nvim-lspconfig'),
    u.gh('mason-org/mason.nvim'),
  })
  require('plugin.dap')
  require('plugin.edit')
  require('plugin.git')
  require('plugin.maplayer')
  require('plugin.other')
  require('plugin.tool')
  require('plugin.ui')
end)
