require'telescope'.setup({
    defaults = {
        mappings = {
            i = {
                ['<c-p>'] = false,
                ['<c-n>'] = false,
                ['<c-f>'] = false,
                ['<tab>'] = false,
                ['<s-tab>'] = false,
                ['<c-j>'] = 'move_selection_next',
                ['<c-k>'] = 'move_selection_previous',
            },
            n = {
                ['<c-n>'] = 'close',
            }
        },
        layout_strategy = "vertical",
        layout_config = {
            vertical = {
                anchor = 'N',
                height = 0.75,
                width = 0.75,
                prompt_position = 'top',
            },
        },
        file_ignore_patterns = {'.git', 'build', 'lib', '.root', '%.o', '%.out', '%.exe', '%.png',
            '%.jpg'},
        sorting_strategy = "ascending",
--         initial_mode = "insert",
--         prompt_prefix = "🔍 ",
--         selection_caret = "❯ ",
--         entry_prefix = "  ",
--         selection_strategy = "reset",
--         file_sorter = require'telescope.sorters'.get_fuzzy_file,
--         generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
--         path_display = {
--             "shorten",
--         },
--         winblend = 0,
--         border = {},
--         borderchars = {
--             "─",
--             "│",
--             "─",
--             "│",
--             "╭",
--             "╮",
--             "╯",
--             "╰",
--         },
--         color_devicons = true,
--         use_less = true,
--         set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
--         file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
--         grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
--         qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    },
--     extensions = {
--         fzf = {
--             fuzzy = true,                    -- false will only do exact matching
--             override_generic_sorter = false, -- override the generic sorter
--             override_file_sorter = true,     -- override the file sorter
--             case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
--             -- the default case_mode is "smart_case"
--         }
--     }
})
