local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- TODO: undotree vim-which-key tabular
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    {
        'stevearc/aerial.nvim',
        config = function() require'plugin_config/aerial_config' end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
    },
    {
        'luozhiya/fittencode.nvim',
        config = function() require('plugin_config/fittencode_config') end,
    },
--     {
--         'github/copilot.vim',
--         lazy = false,
--         init = function() require'plugin_config/copilot_config' end,
--     },
    {
        'preservim/nerdcommenter',
        init = function() require'plugin_config/nerdcommenter_config' end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function() require'plugin_config/lualine_config' end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function ()
            require'tokyonight'.setup()
            vim.cmd [[colorscheme tokyonight-night]]
        end,
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        opts = {},
    },
    {
        'akinsho/bufferline.nvim',
        version = '*',
        dependencies = { 'famiu/bufdelete.nvim' },
        config = function() require'plugin_config/bufferline_config' end,
    },
    {
        'neoclide/coc.nvim',
        branch = 'release',
        init = function() require('plugin_config/coc_config') end
    },
    {
        'vimwiki/vimwiki',
        lazy = false,
        init = function() require('plugin_config/vimwiki_config') end
    },
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
--          "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
--             { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
        init = function() require'plugin_config/vimtmuxnavigator_config' end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = function() require('nvim-treesitter.install').update({ with_sync = true })() end,
        config = function() require'plugin_config/nvimtreesitter_config' end,
        dependencies = {
            'p00f/nvim-ts-rainbow',
            'nvim-treesitter/nvim-treesitter-context',
            'JoosepAlviste/nvim-ts-context-commentstring',
            -- TODO: check which one is needed
--             'nvim-treesitter/nvim-treesitter-textobjects',
--             'windwp/nvim-ts-autotag',
--             'andymass/vim-matchup',
--             'mfussenegger/nvim-treehopper',
        },
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
--         config = function() require'nvim-tree'.setup() end
        config = function() require("plugin_config/nvimtree_config") end,
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
            },
        },
        config = function() require'plugin_config/telescope_config' end,
    },
    {
        "nvim-telescope/telescope-frecency.nvim",
        config = function() require'telescope'.load_extension 'frecency' end,
        dependencies = {"tami5/sqlite.lua"},   -- need to install sqlite lib
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        build = function() require("telescope").load_extension("ui-select") end,
    },
    {
        'jiangmiao/auto-pairs',
        event = {'InsertEnter'},
        init = function() require'plugin_config/autopairs_config' end,
        -- lazy.nvim fails to load, we must initialize auto-pairs manually
        config = function() vim.cmd[[call AutoPairsInit()]] end,
     },
})
