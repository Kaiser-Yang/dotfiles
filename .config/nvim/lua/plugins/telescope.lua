return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make'
        }
    },
    config = function()
        local actions = require('telescope.actions')
        local telescope = require('telescope')
        local builtin = require('telescope.builtin')
        local feedkeys = require('utils').feedkeys
        local map_set = require('utils').map_set
        telescope.setup({
            defaults = {
                dynamic_preview_title = true,
                default_mappings = {},
                mappings = {
                    i = {
                        ['<cr>'] = actions.select_default,
                        ['<c-u>'] = actions.preview_scrolling_up,
                        ['<c-d>'] = actions.preview_scrolling_down,
                        ['<c-j>'] = actions.move_selection_next,
                        ['<c-k>'] = actions.move_selection_previous,
                    },
                    n = {
                        ['<cr>'] = actions.select_default,
                        ['q'] = actions.close,
                        ['<esc>'] = actions.close,
                        ['<c-n>'] = actions.close,
                        ['<c-u>'] = actions.preview_scrolling_up,
                        ['<c-d>'] = actions.preview_scrolling_down,
                        ['j'] = actions.move_selection_next,
                        ['k'] = actions.move_selection_previous,
                        ['gg'] = actions.move_to_top,
                        ['G'] = actions.move_to_bottom,
                        ['<c-j>'] = actions.nop,
                        ['<c-k>'] = actions.nop,
                        ['0'] = function()
                            -- '🔍 ' has a visible length of 3, so we use 4
                            feedkeys('4<bar>', 'n')
                        end,
                        ['^'] = function()
                            -- '🔍 ' has a visible length of 3, so we use 4
                            local cnt = 4
                            local line = vim.api.nvim_get_current_line()
                            -- '🔍 ' this is the prompt prefix whose length is 5
                            for i = 6, #line do
                                if line:sub(i, i) == ' ' then
                                    cnt = cnt + 1
                                else
                                    break
                                end
                            end
                            feedkeys(tostring(cnt) .. '<bar>', 'n')
                        end,
                    }
                },
                layout_strategy = 'flex',
                layout_config = {
                    horizontal = {
                        height = 0.75,
                        width = 0.75,
                        prompt_position = 'top'
                    },
                    vertical = {
                        height = 0.75,
                        width = 0.75,
                        prompt_position = 'top',
                    },
                    flex = {
                        flip_columns = 170,
                        horizontal = {
                            height = 0.75,
                            width = 0.75,
                            prompt_position = 'top',
                            preview_width = 0.6,
                        },
                        vertical = {
                            height = 0.75,
                            width = 0.75,
                            prompt_position = 'top',
                            preview_height = 0.6,
                        },
                    }
                },
                sorting_strategy = 'ascending',
                file_ignore_patterns = { '%.git', '%.root',
                    '%.o', '%.out', '%.exe', '%.png', '%.gif',
                    '%.jpg', '%.so', '%.a', '%.dll', '%.dylib', '%.class', '%.jar', '%.zip',
                    '%.tar.gz', },
                prompt_prefix = '🔍 ',
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = 'smart_case',
                },
            },
            pickers = {
                live_grep = {
                    mappings = {
                        i = {
                            ['<c-f>'] = actions.close
                        },
                        n = {
                            ['<c-f>'] = actions.close
                        }
                    },
                },
                find_files = {
                    mappings = {
                        i = {
                            ['<c-p>'] = actions.close
                        },
                        n = {
                            ['<c-p>'] = actions.close
                        }
                    },
                },
                spell_suggest = {
                    initial_mode = 'normal',
                },
                lsp_references = {
                    initial_mode = 'normal',
                },
                diagnostics = {
                    initial_mode = 'normal',
                },
            },
        })
        require('telescope').load_extension('fzf')
        map_set({ 'n', 'i' }, '<c-p>', function()
            builtin.find_files({
                cwd = require('utils').get_root_directory(),
                hidden = true,
            })
        end)
        map_set({ 'n', 'i' }, '<c-f>', function()
            builtin.live_grep({
                cwd = require('utils').get_root_directory(),
                additional_args = { '--hidden', },
            })
        end)
        map_set({ 'n' }, '<leader><leader>', builtin.current_buffer_fuzzy_find,
            { desc = 'Current buffer fuzzy find' })
        map_set({ 'n' }, 'z=', builtin.spell_suggest, { desc = 'Spell suggestions' })
        map_set({ 'n' }, 'gr', builtin.lsp_references, { desc = 'Go to references' })
        -- disable mouse when open telescope
        -- we do this because mouse events in telescope will close the window
        vim.api.nvim_create_autocmd('FileType', {
            group = 'UserDIY',
            pattern = 'TelescopePrompt',
            command = 'setlocal mouse=',
        })
        vim.api.nvim_create_autocmd('BufEnter', {
            group = 'UserDIY',
            pattern = '*',
            callback = function()
                if vim.o.filetype ~= 'TelescopePrompt' then
                    vim.o.mouse = 'a'
                end
            end,
        })
    end,
}
