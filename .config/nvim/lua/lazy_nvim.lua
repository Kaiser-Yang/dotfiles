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
DisableCopilot = false
require('lazy').setup({
    -- TODO: undotree tabular
    spec = {
        {
            "williamboman/mason.nvim",
            -- do not update this with config, nvim-java requires this be loaded with opts
            opts = function() require 'plugin_config/mason_config' end,
        },
        {
            'williamboman/mason-lspconfig.nvim',
            dependencies = {
                "williamboman/mason.nvim",
            },
            config = function() require 'plugin_config/masonlspconfig_config' end,
        },
        {
            'neovim/nvim-lspconfig',
            dependencies = {
                'williamboman/mason-lspconfig.nvim',
                'saghen/blink.cmp'
            },
            config = function() require 'plugin_config/nvimlspconfig_config' end,
        },
        -- TODO: remove those two plugins when configurations are stable
        -- lazydev is for nvim configuration function completion
        {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = { require 'plugin_config/lazydev_config' },
        },
        -- optional `vim.uv` typings, this is for lazydev
        {
            "Bilal2453/luvit-meta",
            lazy = true
        },
        { require('plugin_config/blinkcmp_config') },
        {
            'nvimdev/lspsaga.nvim',
            config = function() require 'plugin_config/lspsaga_config' end,
            event = 'LspAttach',
            dependencies = {
                'nvim-treesitter/nvim-treesitter', -- optional
                'nvim-tree/nvim-web-devicons',     -- optional
            }
        },

        {
            'akinsho/git-conflict.nvim',
            version = "*",
            config = function() require 'plugin_config/gitconflict_config' end,
        },
        {
            'lewis6991/gitsigns.nvim',
            config = function() require 'plugin_config/gitsigns_config' end,
        },

        { require('plugin_config.indent_blankline') },
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            config = function() require 'plugin_config/lualine_config' end,
        },
        { 'AndreM222/copilot-lualine' },
        {
            "folke/tokyonight.nvim",
            lazy = false,
            priority = 1000,
            config = function()
                require 'tokyonight'.setup()
                vim.cmd [[colorscheme tokyonight-night]]
            end,
        },
        {
            'akinsho/bufferline.nvim',
            version = '*',
            dependencies = { 'famiu/bufdelete.nvim' },
            config = function() require 'plugin_config/bufferline_config' end,
        },

        {
            'zbirenbaum/copilot.lua',
            cmd = 'Copilot',
            event = 'InsertEnter',
            config = function() require 'plugin_config/copilotlua_config' end,
        },

        {
            'gbprod/yanky.nvim',
            config = function() require 'plugin_config/yanky_config' end,
        },
        {
            'numToStr/Comment.nvim',
            config = function() require 'plugin_config/comment_config' end,
        },
        { require('plugin_config/ultimate-autopairs_config') },
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
            'vimwiki/vimwiki',
            lazy = false,
            init = function() require('plugin_config/vimwiki_config') end
        },
        {
            'mzlogin/vim-markdown-toc',
            ft = { "markdown", "vimwiki" },
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
            init = function() require 'plugin_config/vimtmuxnavigator_config' end
        },
        {
            "folke/todo-comments.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function() require 'plugin_config/todocomments_config' end,
        },
        -- formatter
        { require 'plugin_config/conform_config' },

        {
            'nvim-treesitter/nvim-treesitter',
            build = function() require('nvim-treesitter.install').update({ with_sync = true })() end,
            config = function() require 'plugin_config/nvimtreesitter_config' end,
            dependencies = {
                {
                    'nvim-treesitter/nvim-treesitter-context',
                    opts = {
                        max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
                    }
                }
                -- FIX: this will cause problems
                -- 'p00f/nvim-ts-rainbow',
            },
        },
        {
            'JoosepAlviste/nvim-ts-context-commentstring',
            config = function() require 'plugin_config/nvimtscontextcommentstring_config' end,
        },
        {
            'andymass/vim-matchup',
            config = function() require 'plugin_config/vimmatchup_config' end,
        },
        {
            'windwp/nvim-ts-autotag',
            config = function() require 'plugin_config/nvimtsautotag_config' end,
        },

        -- NOTE: if you want to open session when next time use nvim, you should use :qa to quit
        {
            'rmagatti/auto-session',
            dependencies = {
                'nvim-telescope/telescope.nvim', -- Only needed if you want to use sesssion lens
            },
            config = function() require 'plugin_config/autosession_config' end,
        },
        {
            "nvim-tree/nvim-tree.lua",
            version = "*",
            lazy = false,
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function() require("plugin_config/nvimtree_config") end,
        },
        {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.8',
            dependencies = {
                'nvim-lua/plenary.nvim',
                {
                    'nvim-telescope/telescope-fzf-native.nvim',
                    build =
                    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
                },
            },
            config = function() require 'plugin_config/telescope_config' end,
        },
        {
            "rcarriga/nvim-notify",
            config = function() require 'plugin_config/nvimnotify_config' end,
        },
        {
            "folke/noice.nvim",
            event = "VeryLazy",
            config = function() require 'plugin_config/noice_config' end,
            dependencies = {
                "MunifTanjim/nui.nvim",
                "rcarriga/nvim-notify",
            }
        },
        {
            "Pocco81/auto-save.nvim",
            opts = {
                execution_message = {
                    message = ""
                }
            },
        },
        {
            'folke/which-key.nvim',
            event = 'VeryLazy',
            config = function() require 'plugin_config/whichkey_config' end,
        },
        {
            'RRethy/vim-illuminate',
            config = function() require 'plugin_config/vimilluminate_config' end,
        },

        {
            "rcarriga/nvim-dap-ui",
            dependencies = {
                "mfussenegger/nvim-dap",
                "nvim-neotest/nvim-nio",
                'theHamsta/nvim-dap-virtual-text',
            },
            config = function() require 'plugin_config/nvimdap_config' end,
        },
        {
            'nvim-java/nvim-java',
        },
        {
            'akinsho/toggleterm.nvim',
            config = function() require 'plugin_config/toggleterm_config' end,
        },

        {
            "folke/zen-mode.nvim",
            opts = function() require 'plugin_config/zenmode_config' end,
            dependencies = {
                {
                    "folke/twilight.nvim",
                    opts = function() require 'plugin_config/twilight_config' end,
                }
            }
        },
        {
            "lervag/vimtex",
            lazy = false, -- we don't want to lazy load VimTeX
            init = function() require 'plugin_config/vimtex_config' end,
        },
        {
            'L3MON4D3/LuaSnip',
            version = "v2.*",
            build = 'make install_jsregexp',
            dependencies = {
                'rafamadriz/friendly-snippets',
            },
            config = function() require 'plugin_config/luasnip_config' end,
        },

        -- {
        --     'dgagn/diagflow.nvim',
        --     event = 'LspAttach',
        --     config = function() require'plugin_config/diagflow_config' end,
        -- },
        -- INFO: now use nvim-java which is easy to configure
        -- {
        --     "mfussenegger/nvim-jdtls",
        --     ft = { "java" },
        --     dependencies = {
        --         "mfussenegger/nvim-dap",
        --     }
        -- },
        -- INFO: now use copilot + copilot-chat
        -- the key mappings for fittencode is not finished yet
        -- {
        --     'luozhiya/fittencode.nvim',
        --     config = function()
        --         require'plugin_config/fittencode_config'
        --     end,
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
        -- INFO: rarely used
        -- { import = 'plugin_config/copilotchat_config' },
        -- INFO: now we use cmp-blink
        -- {
        --     'hrsh7th/nvim-cmp',
        --     dependencies = {
        --         'hrsh7th/cmp-nvim-lsp',
        --         'hrsh7th/cmp-buffer',
        --         'hrsh7th/cmp-path',
        --         'hrsh7th/cmp-cmdline',
        --         'onsails/lspkind-nvim',
        --         'lukas-reineke/cmp-rg',
        --         'saadparwaiz1/cmp_luasnip',
        --         {
        --             'L3MON4D3/LuaSnip',
        --             version = "v2.*",
        --             build = 'make install_jsregexp',
        --             dependencies = {
        --                 'rafamadriz/friendly-snippets',
        --             },
        --             config = function() require'plugin_config/luasnip_config' end,
        --         },
        --         'uga-rosa/cmp-dictionary',
        --         {
        --             "petertriho/cmp-git",
        --             config = function () require'cmp_git'.setup() end,
        --         },
        --         -- comparators making underlines lower priority
        --         'lukas-reineke/cmp-under-comparator',
        --         "micangl/cmp-vimtex",
        --         -- TODO: remove this plugin when configurations are stable
        --         'hrsh7th/cmp-nvim-lua',
        --     },
        --     config = function() require'plugin_config/nvimcmp_config' end,
        -- },
    }
})
