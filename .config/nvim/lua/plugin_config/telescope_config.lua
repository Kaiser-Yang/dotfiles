require'telescope'.setup({
    pickers = {
        lsp_references = {
            mappings = {
                n = {
                    ['<c-n>'] = 'close',
                    ['q'] = 'close',
                }
            },
            layout_strategy = "vertical",
            layout_config = {
                vertical = {
                    anchor = 'S',
                    height = 0.5,
                    preview_height = 0.3,
                    width = { padding = 0 },
                    prompt_position = 'bottom',
                },
            },
            initial_mode = 'normal',
        },
    },
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
                ['q'] = 'close',
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
        file_ignore_patterns = {'.git/', 'build/', 'lib/', '.root', '%.o', '%.out', '%.exe', '%.png',
            '%.jpg', '%.so', '%.a', '%.dll', '%.dylib', '%.class', '%.jar', '%.zip', '%.tar.gz',},
        sorting_strategy = "ascending",
        prompt_prefix = "🔍 ",
        set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
    },
    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        }
    }
})
require('telescope').load_extension('fzf')
