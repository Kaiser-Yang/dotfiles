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
CopilotDisable = false
require('lazy').setup({
    -- TODO: undotree vim-which-key tabular
    spec = {
        {
            'gbprod/yanky.nvim',
            config = function() require'plugin_config/yanky_config' end,
        },
        {
            'akinsho/git-conflict.nvim',
            version = "*",
            config = function() require'plugin_config/gitconflict_config' end,
        },
        {
            'lewis6991/gitsigns.nvim',
            config = function() require'plugin_config/gitsigns_config' end,
        },
        {
            "williamboman/mason.nvim",
            dependencies = {
                'williamboman/mason-lspconfig.nvim',
                -- "mason-org/mason-registry",
            },
            config = function () require"plugin_config/mason_config" end,
        },
        {
            'neovim/nvim-lspconfig',
            config = function() require'plugin_config/nvimlspconfig_config' end,
        },
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'hrsh7th/cmp-cmdline',
                'hrsh7th/cmp-nvim-lua',
                'onsails/lspkind-nvim',
                'saadparwaiz1/cmp_luasnip',
                {
                    'L3MON4D3/LuaSnip',
                    build = 'make install_jsregexp || true',
                    dependencies = {
                        'rafamadriz/friendly-snippets',
                    },
                    config = function() require'plugin_config/luasnip_config' end,
                },
                -- 'uga-rosa/cmp-dictionary',
                -- 'hrsh7th/cmp-nvim-lsp-signature-help',
                -- 'f3fora/cmp-spell',
                -- 'hrsh7th/cmp-calc',
                -- 'chrisgrieser/cmp_yanky',
                -- 'petertriho/cmp-git',
                -- 'lukas-reineke/cmp-rg',
                -- 'roobert/tailwindcss-colorizer-cmp.nvim',
                -- "lukas-reineke/cmp-under-comparator",
                -- 'hrsh7th/cmp-copilot', -- INFO: uncomment this for AI completion
                -- {
                --     'Ninlives/cmp-rime',
                --     run = ':UpdateRemotePlugins | !rm -rf /tmp/tmp-pyrime && git clone https://github.com/Ninlives/pyrime /tmp/tmp-pyrime && cd /tmp/tmp-pyrime && python setup.py install --prefix ~/.local',
                -- },
                -- {
                --     os.getenv('ARCHIBATE_COMPUTER') and '/home/bate/Codes/cmp-rime' or 'archibate/cmp-rime',
                --     run = 'make',
                -- },
            },
            config = function() require'plugin_config/nvimcmp_config' end,
        },
        {
            'dgagn/diagflow.nvim',
            event = 'LspAttach',
            config = function() require'plugin_config/diagflow_config' end,
        },
        {
            'nvimdev/lspsaga.nvim',
            config = function() require'plugin_config/lspsaga_config' end,
            event = 'LspAttach',
            dependencies = {
                'nvim-treesitter/nvim-treesitter', -- optional
                'nvim-tree/nvim-web-devicons',     -- optional
            }
        },
        -- {
        --     'ray-x/lsp_signature.nvim',
        --     config = function() require'plugin_config/lspsignature_config' end,
        -- },

        {
            'github/copilot.vim',
            lazy = false,
            init = function() require'plugin_config/copilot_config' end,
        },
        { import = 'plugin_config/copilotchat_config' },

        -- Now use lspsaga outline
        -- {
        --     'stevearc/aerial.nvim',
        --     config = function() require'plugin_config/aerial_config' end,
        --     dependencies = {
        --         "nvim-treesitter/nvim-treesitter",
        --         "nvim-tree/nvim-web-devicons"
        --     },
        -- },
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
            'akinsho/bufferline.nvim',
            version = '*',
            dependencies = { 'famiu/bufdelete.nvim' },
            config = function() require'plugin_config/bufferline_config' end,
        },

        {
            'preservim/nerdcommenter',
            init = function() require'plugin_config/nerdcommenter_config' end,
        },
        {
            'jiangmiao/auto-pairs',
            event = {'InsertEnter'},
            init = function() require'plugin_config/autopairs_config' end,
            -- lazy.nvim fails to load, we must initialize auto-pairs manually
            config = function() vim.cmd[[call AutoPairsInit()]] end,
        },
        {
            "kylechui/nvim-surround",
            version = "*", -- Use for stability; omit to use `main` branch for the latest features
            event = "VeryLazy",
            opts = {},
        },

        {
            "iamcco/markdown-preview.nvim",
            cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
            ft = { "markdown" },
            build = function() vim.fn["mkdp#util#install"]() end,
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
                "TmuxNavigatePrevious",
            },
            keys = {
                { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
                { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
                { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
                { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
                -- { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
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
                -- 'nvim-treesitter/nvim-treesitter-textobjects',
                -- 'windwp/nvim-ts-autotag',
                -- 'andymass/vim-matchup',
                -- 'mfussenegger/nvim-treehopper',
            },
        },
        {
            "nvim-tree/nvim-tree.lua",
            version = "*",
            lazy = false,
            dependencies = { "nvim-tree/nvim-web-devicons" },
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
            "rcarriga/nvim-notify",
            config = function () require'plugin_config/nvimnotify_config' end,
        },
        {
            "folke/noice.nvim",
            event = "VeryLazy",
            config = function () require'plugin_config/noice_config' end,
            dependencies = {
                -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
                "MunifTanjim/nui.nvim",
                -- OPTIONAL:
                --   `nvim-notify` is only needed, if you want to use the notification view.
                --   If not available, we use `mini` as the fallback
                "rcarriga/nvim-notify",
              }
        },
        {
            "Pocco81/auto-save.nvim",
            opts = {},
        },

        {
            "rcarriga/nvim-dap-ui",
            dependencies = {
                "mfussenegger/nvim-dap",
                "nvim-neotest/nvim-nio",
                'theHamsta/nvim-dap-virtual-text',
            },
            config = function () require 'plugin_config/nvimdap_config' end,
        },
        {
            "mfussenegger/nvim-jdtls",
            dependencies = {
                "mfussenegger/nvim-dap",
            }
        },
        -- {
        --         'neoclide/coc.nvim',
        --         branch = 'master',
        --         build = 'npm ci',
        --         init = function() require('plugin_config/coc_config') end
        -- },
        -- {
        --     'luozhiya/fittencode.nvim',
        --     config = function()
        --         require'plugin_config/fittencode_config'
        --     end,
        -- },
    }
})
