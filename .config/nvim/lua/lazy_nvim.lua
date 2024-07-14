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
    -- TODO: undotree tabular
    spec = {
        {
            "williamboman/mason.nvim",
            -- do not update this with config, nvim-java requires this be loaded with opts
            opts = function () require'plugin_config/mason_config' end,
        },
        {
            'williamboman/mason-lspconfig.nvim',
            dependencies = {
                "williamboman/mason.nvim",
            },
            config = function () require'plugin_config/masonlspconfig_config' end,
        },
        {
            'neovim/nvim-lspconfig',
            dependencies = {
                'williamboman/mason-lspconfig.nvim',
            },
            config = function() require'plugin_config/nvimlspconfig_config' end,
        },
        -- lazydev is for nvim configuration function completion
        {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = { require'plugin_config/lazydev_config' },
        },
        { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'hrsh7th/cmp-cmdline',
                'hrsh7th/cmp-nvim-lua',
                'hrsh7th/cmp-calc',
                'chrisgrieser/cmp_yanky',
                'onsails/lspkind-nvim',
                'uga-rosa/cmp-dictionary',
                'f3fora/cmp-spell',
                'petertriho/cmp-git',
                'lukas-reineke/cmp-rg',
                'saadparwaiz1/cmp_luasnip',
                {
                    'L3MON4D3/LuaSnip',
                    version = "v2.*",
                    build = 'make install_jsregexp',
                    dependencies = {
                        'rafamadriz/friendly-snippets',
                    },
                    config = function() require'plugin_config/luasnip_config' end,
                },
                -- comparators making underlines lower priority
                'lukas-reineke/cmp-under-comparator'

                -- input method of Chinese
                -- 'yehuohan/cmp-im',
                -- 'yehuohan/cmp-im-zh',

                -- 'roobert/tailwindcss-colorizer-cmp.nvim', -- INFO: uncomment this for css color
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
            'github/copilot.vim',
            lazy = false,
            init = function() require'plugin_config/copilot_config' end,
        },
        { import = 'plugin_config/copilotchat_config' },

        {
            'gbprod/yanky.nvim',
            config = function() require'plugin_config/yanky_config' end,
        },
        {
            'numToStr/Comment.nvim',
            config = function() require'plugin_config/comment_config' end,
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
            build = "cd app && yarn install",
            ft = { "markdown", "vimwiki", "gitcommit" },
            init = function() vim.g.mkdp_filetypes = { "markdown", "vimwiki", "gitcommit" } end,
            dependencies = { 'iamcco/mathjax-support-for-mkdp' }
        },
        {
            'mzlogin/vim-markdown-toc',
            ft = { "markdown", "vimwiki" },
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
            "folke/todo-comments.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function() require'plugin_config/todocomments_config' end,
        },
        {
            require'plugin_config/conform_config'
        },
        {
            'nvim-treesitter/nvim-treesitter',
            build = function() require('nvim-treesitter.install').update({ with_sync = true })() end,
            config = function() require'plugin_config/nvimtreesitter_config' end,
            dependencies = {
                'nvim-treesitter/nvim-treesitter-context',
                -- FIX: this will cause problems
                -- 'p00f/nvim-ts-rainbow',
            },
        },
        {
            'JoosepAlviste/nvim-ts-context-commentstring',
            config = function() require'plugin_config/nvimtscontextcommentstring_config' end,
        },
        {
            'andymass/vim-matchup',
            config = function() require'plugin_config/vimmatchup_config' end,
        },
        {
            'windwp/nvim-ts-autotag',
            config = function() require'plugin_config/nvimtsautotag_config' end,
        },
        -- NOTE: if you want to open session when next time use nvim, you should use :qa to quit
        {
            'rmagatti/auto-session',
            dependencies = {
                'nvim-telescope/telescope.nvim', -- Only needed if you want to use sesssion lens
            },
            config = function() require'plugin_config/autosession_config' end,
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
            'folke/which-key.nvim',
            event = 'VeryLazy',
            config = function() require'plugin_config/whichkey_config' end,
        },
        {
            'RRethy/vim-illuminate',
            config = function() require'plugin_config/vimilluminate_config' end,
        },
        {
            "folke/zen-mode.nvim",
            opts = function() require'plugin_config/zenmode_config' end,
        },
        {
            "folke/twilight.nvim",
            opts = function() require'plugin_config/twilight_config' end,
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
            'nvim-java/nvim-java',
        },
        { 'dstein64/vim-startuptime' },

        -- INFO: now use nvim-java which is easy to configure
        -- {
        --     "mfussenegger/nvim-jdtls",
        --     ft = { "java" },
        --     dependencies = {
        --         "mfussenegger/nvim-dap",
        --     }
        -- },
        -- INFO: now use cmp + lsp + mason
        -- {
        --         'neoclide/coc.nvim',
        --         branch = 'master',
        --         build = 'npm ci',
        --         init = function() require('plugin_config/coc_config') end
        -- },
        -- INFO: now use copilot + copilot-chat
        -- the key mappings for fittencode is not finished yet
        -- {
        --     'luozhiya/fittencode.nvim',
        --     config = function()
        --         require'plugin_config/fittencode_config'
        --     end,
        -- },
        -- INFO: now use lspsaga outline
        -- {
        --     'stevearc/aerial.nvim',
        --     config = function() require'plugin_config/aerial_config' end,
        --     dependencies = {
        --         "nvim-treesitter/nvim-treesitter",
        --         "nvim-tree/nvim-web-devicons"
        --     },
        -- },
        -- NOTE: now use comment.nvim
        -- {
        --     'preservim/nerdcommenter',
        --     init = function() require'plugin_config/nerdcommenter_config' end,
        -- },
        -- INFO: for signature, uncomment those lines to use
        -- {
        --     'ray-x/lsp_signature.nvim',
        --      event = "VeryLazy",
        --     config = function() require'plugin_config/lspsignature_config' end,
        -- },
        -- INFO: not used now
        -- {
        --     'mfussenegger/nvim-treehopper',
        -- },
        -- INFO: not used now
        -- {
        --     'nvim-treesitter/nvim-treesitter-textobjects',
        --     dependencies = {
        --         'nvim-treesitter/nvim-treesitter',
        --     },
        -- },
        -- INFO: I find that I never use this plugin
        -- {
        --     "nvim-telescope/telescope-frecency.nvim",
        --     config = function() require'telescope'.load_extension 'frecency' end,
        -- },
        -- INFO: I find that I never use this plugin
        -- {
        --     "nvim-telescope/telescope-ui-select.nvim",
        --     build = function() require("telescope").load_extension("ui-select") end,
        -- },
        -- TODO: using this to substitute my own configured terminal may be better
        -- {
        --     'akinsho/toggleterm.nvim',
        --     config = function() require'archvim/config/toggleterm' end,
        -- },
    }
})
