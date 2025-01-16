return {
    -- Appearance
    require('plugins.color_scheme'),
    require('plugins.buffer_line'),
    require('plugins.lua_line'),
    require('plugins.indent_blank_line'),
    require('plugins.explorer'),
    require('plugins.smooth_scroll'),
    require('plugins.smooth_cursor'),

    -- LSP
    require('plugins.mason'),
    require('plugins.mason_lsp_config'),
    require('plugins.lsp_config'),
    require('plugins.lsp_saga'),
    require('plugins.lazy_dev'),
    require('plugins.lsp_lens'),

    -- Completion
    require('plugins.blink_cmp'),
    require('plugins.snippets'),

    require('plugins.telescope'),

    require('plugins.formatter'),

    require('plugins.debugger'),

    require('plugins.git_signs'),
    require('plugins.git_conflict'),

    require('plugins.copilot'),

    require('plugins.table_mode'),
    require('plugins.markdown_toc'),
    require('plugins.markdown_render'),
    require('plugins.markdown_preview'),

    require('plugins.tree_sitter'),

    require('plugins.yanky'),
    require('plugins.auto_save'),
    require('plugins.auto_session'),
    require('plugins.comment'),
    require('plugins.surround'),
    require('plugins.auto_pairs'),
    require('plugins.which_key'),
    require('plugins.tmux_navigator'),
    require('plugins.todo_comments'),
    require('plugins.noice'),
    require('plugins.notify'),
    require('plugins.illuminate'),
    require('plugins.terminal'),
    require('plugins.zen_mode'),
    require('plugins.auto_tag'),
    require('plugins.big_file'),

    require('plugins.latex'),

    -- require('plugins.rainbow_delimiter'),

    -- {
    --     'dgagn/diagflow.nvim',
    --     event = 'LspAttach',
    --     config = function() require'plugin_config/diagflow_config' end,
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
