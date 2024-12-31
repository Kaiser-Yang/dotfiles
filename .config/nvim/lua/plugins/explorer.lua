-- map_set({ 'n' }, 'y', api.fs.copy.filename, opts('Copy Name'))
return {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
        'nvim-treesitter/nvim-treesitter-textobjects',
        {
            's1n7ax/nvim-window-picker',
            version = '2.*',
            config = function()
                require 'window-picker'.setup({
                    filter_rules = {
                        include_current_win = false,
                        autoselect_one = true,
                        bo = {
                            filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
                            buftype = { 'terminal', 'quickfix' },
                        },
                    },
                    prompt_message = '',
                    highlights = {
                        statusline = {
                            unfocused = {
                                fg = '#ededed',
                                bg = '#3fa4cc',
                                bold = true,
                            },
                        },
                    },
                })
            end,
        },
    },
    config = function()
        local feedkeys = require('utils').feedkeys
        local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
        local map_set = require('utils').map_set
        local next_git_repeat, prev_git_repeat = ts_repeat_move.make_repeatable_move_pair(
            require('neo-tree.sources.filesystem.commands').next_git_modified,
            require('neo-tree.sources.filesystem.commands').prev_git_modified)
        -- TODO:
        -- local next_diagnostic_repeat, prev_diagnostic_repeat = ts_repeat_move.make_repeatable_move_pair(
        --     api.node.navigate.diagnostics.next,
        --     api.node.navigate.diagnostics.prev)
        require('neo-tree').setup({
            sources                   = {
                'filesystem',
                'git_status',
                'document_symbols',
            },
            source_selector           = {
                winbar = true,
                sources = {
                    { source = 'git_status' },
                    { source = 'document_symbols' },
                    { source = 'filesystem' },
                }
            },
            sort_case_insensitive     = true,
            use_default_mappings      = false,
            event_handlers            = {
                {
                    event = 'neo_tree_buffer_enter',
                    handler = function(_)
                        local mode = vim.api.nvim_get_mode().mode;
                        if mode == 'i' or mode == 'I' then
                            feedkeys('<esc>', 'n')
                        end
                        vim.wo.number = true
                        vim.wo.relativenumber = true
                        vim.wo.colorcolumn = ''
                    end
                },
                {
                    event = 'neo_tree_window_before_open',
                    handler = function(_)
                        vim.g.explorer_visible = true
                    end
                },
                {
                    event = 'neo_tree_window_before_close',
                    handler = function(_)
                        vim.g.explorer_visible = false
                    end
                },
                {
                    event = 'neo_tree_window_after_open',
                    handler = function(_)
                        vim.cmd('wincmd =')
                    end
                },
                {
                    event = 'after_render',
                    handler = function(_)
                    end
                },
            },
            default_component_configs = {
                git_status = {
                    symbols = {
                        modified  = '',
                        renamed   = '➜',
                        untracked = '★',
                        ignored   = '◌',
                        unstaged  = '✗',
                        staged    = '✓',
                    },
                    width = 2,
                    align = 'left',
                },
                file_size = {
                    align = 'right',
                    required_width = 0,
                },
                last_modified = {
                    align = 'right',
                    required_width = 0,
                },
                symlink_target = {
                    enabled = true,
                    align = 'right',
                    required_width = 0,
                },
                created = {
                    enabled = true,
                    align = 'right',
                    required_width = 0,
                }
            },
            window                    = {
                width = function()
                    return math.ceil(math.max(40, 0.15 * vim.o.columns))
                end,
                mappings = {
                    ['e'] = 'toggle_auto_expand_width',
                    ['<2-LeftMouse>'] = {
                        function(state)
                            local node = state.tree:get_node()
                            if node.type ~= 'directory' and not node:has_children() then
                                require('neo-tree.sources.common.commands').open_with_window_picker(state)
                            else
                                state.commands.toggle_node(state)
                            end
                        end,
                        desc = 'Toggle or Open'
                    },
                    ['<c-c>'] = 'cancel',
                    ['<leader>j'] = 'split_with_window_picker',
                    ['<leader>l'] = 'vsplit_with_window_picker',
                    ['H'] = 'close_all_nodes',
                    ['L'] = {
                        function(state)
                            local function expand(u)
                                if u == nil then return end
                                if not u:is_expanded() then u:expand() end
                                for _, v in ipairs(state.tree:get_nodes(u:get_id())) do
                                    expand(v)
                                end
                            end
                            require('plenary.async').run(function()
                                expand(state.tree:get_nodes()[1])
                            end, function()
                                require('neo-tree.ui.renderer').redraw(state)
                            end)
                        end,
                        desc = 'expand_all_nodes',
                    },
                    ['<'] = 'prev_source',
                    ['>'] = 'next_source',
                    ['<f5>'] = 'refresh',
                    ['?'] = 'show_help',
                    ['<leader>n'] = 'next_source',
                    ['<leader>b'] = 'prev_source',
                    ['h'] = {
                        function(state)
                            local node = state.tree:get_node()
                            if node:is_expanded() then
                                state.commands.toggle_node(state)
                            else
                                require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
                            end
                        end,
                        desc = 'Collapse or Go To Parrent'
                    },
                    ['l'] = {
                        function(state)
                            local node = state.tree:get_node()
                            if node.type ~= 'directory' and not node:has_children() then
                            else
                                state.commands.toggle_node(state)
                            end
                        end,
                        desc = 'Toggle or Open'
                    },
                    -- TODO: laggy and abrupt
                    -- ['P'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = false } },
                }
            },
            filesystem                = {
                window = {
                    mappings = {
                        ['L'] = 'expand_all_nodes',
                        ['a'] = {
                            'add',
                            config = {
                                show_path = 'absolute'
                            }
                        },
                        ['A'] = 'add_directory',
                        ['r'] = 'rename',
                        ['m'] = {
                            'move',
                            config = {
                                show_path = 'absolute'
                            }
                        },
                        ['c'] = {
                            'copy',
                            config = {
                                show_path = 'absolute'
                            }
                        },
                        ['<cr>'] = {
                            function(state)
                                local node = state.tree:get_node()
                                if node.type == 'directory' then
                                    state.commands.set_root(state)
                                else
                                    require('neo-tree.sources.common.commands').open_with_window_picker(state)
                                end
                            end,
                            desc = 'Enter Dir or Open File'
                        },
                        ['<bs>'] = 'navigate_up',
                        [']g'] = {
                            function(state)
                                next_git_repeat(state)
                            end,
                            desc = 'Next Git Modified',
                        },
                        ['[g'] = {
                            function(state)
                                prev_git_repeat(state)
                            end,
                            desc = 'Prev Git Modified',
                        },
                        ['d'] = 'delete',
                        ['y'] = 'copy_to_clipboard',
                        ['x'] = 'cut_to_clipboard',
                        ['p'] = 'paste_from_clipboard',
                        ['<leader>h'] = 'toggle_hidden',
                        ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
                        ['oc'] = { 'order_by_created', nowait = false },
                        ['od'] = { 'order_by_diagnostics', nowait = false },
                        ['og'] = { 'order_by_git_status', nowait = false },
                        ['om'] = { 'order_by_modified', nowait = false },
                        ['on'] = { 'order_by_name', nowait = false },
                        ['os'] = { 'order_by_size', nowait = false },
                        ['ot'] = { 'order_by_type', nowait = false },
                    },
                },
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    never_show = {
                        '.git'
                    },
                },
                find_args = {
                    fd = {
                        '--hidden',
                        '--exclude', '.git', '.root', '*.o', '*.out', '*.exe', '*.png', '*.gif',
                        '*.jpg', '*.so', '*.a', '*.dll', '*.dylib', '*.class', '*.jar', '*.zip',
                        '*.tar.gz'
                    }
                }
            },
            git_status                = {
                window = {
                    mappings = {
                        ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
                        ['oc'] = { 'order_by_created', nowait = false },
                        ['od'] = { 'order_by_diagnostics', nowait = false },
                        ['og'] = { 'order_by_git_status', nowait = false },
                        ['om'] = { 'order_by_modified', nowait = false },
                        ['on'] = { 'order_by_name', nowait = false },
                        ['os'] = { 'order_by_size', nowait = false },
                        ['ot'] = { 'order_by_type', nowait = false },
                    }
                }
            },
            document_symbols          = {
                window = {
                    mappings = {
                        ['<cr>'] = {
                            require('neo-tree.sources.common.commands').open_with_window_picker,
                            desc = 'Enter Dir or Open File'
                        },
                    }
                },
                renderers = {
                    root = {
                        { 'name' },
                    },
                    symbol = {
                        { 'indent',    with_expanders = true },
                        { 'kind_icon', default = '?' },
                        { 'name' },
                        { 'kind_name' },
                    },
                },
            },
            renderers                 = {
                file = {
                    { 'indent' },
                    { 'icon' },
                    { 'git_status' },
                    { 'name' },
                    { 'diagnostics', errors_only = false },
                    { 'clipboard' },
                    {
                        'container',
                        content = {
                            {
                                'symlink_target',
                                highlight = 'NeoTreeSymbolicLinkTarget',
                                zindex = 40
                            },
                            {
                                'file_size',
                                zindex = 30
                            },
                            {
                                'last_modified',
                                zindex = 20
                            },
                            {
                                'created',
                                zindex = 10
                            },
                        }
                    }
                },
                directory = {
                    { 'indent' },
                    { 'icon' },
                    { 'current_filter' },
                    { 'git_status',    hide_when_expanded = true },
                    { 'name' },
                    { 'diagnostics',   errors_only = false,      hide_when_expanded = true },
                    { 'clipboard' },
                    {
                        'container',
                        content = {
                            {
                                'symlink_target',
                                highlight = 'NeoTreeSymbolicLinkTarget',
                                zindex = 40
                            },
                            {
                                'file_size',
                                zindex = 30
                            },
                            {
                                'last_modified',
                                zindex = 20
                            },
                            {
                                'created',
                                zindex = 10
                            },
                        },
                    }
                },
            }
        })
        local get_root_directory = require('utils').get_root_directory
        local function move_cursor_when_visible()
            if vim.g.explorer_visible then
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    if vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), 'filetype') == 'neo-tree' then
                        vim.api.nvim_set_current_win(win)
                        break
                    end
                end
            end
        end
        map_set({ 'n', 'i' }, '<c-q>', function()
            local root_dir = get_root_directory()
            local current_file = vim.fn.expand('%:p')
            move_cursor_when_visible()
            require('neo-tree.command').execute({
                source = 'git_status',
                reveal = true,
                reveal_file = current_file,
                dir = root_dir,
            })
        end)
        -- BUG: the first time use will not set the cursor correctly
        map_set({ 'n', 'i' }, '<c-e>', function()
            local root_dir = get_root_directory()
            local current_file = vim.fn.expand('%:p')
            move_cursor_when_visible()
            require('neo-tree.command').execute({
                source = 'filesystem',
                reveal = true,
                reveal_file = current_file,
                dir = root_dir,
            })
        end)
        map_set({ 'n', 'i' }, '<c-w>', function()
            move_cursor_when_visible()
            require('neo-tree.command').execute({
                source = 'document_symbols',
            })
        end)
        -- TODO:
        -- local feedkeys = require('utils').feedkeys
        -- map_set({ 'n' }, '<leader>J', function()
        --     close_and_open_surround_cb(function() feedkeys('<c-w>J', 'n') end)
        -- end, { desc = 'Reopen window down' })
        -- map_set({ 'n' }, '<leader>K', function()
        --     close_and_open_surround_cb(function() feedkeys('<c-w>K', 'n') end)
        -- end, { desc = 'Reopen window up' })
        -- map_set({ 'n' }, '<leader>H', function()
        --     close_and_open_surround_cb(function() feedkeys('<c-w>H', 'n') end)
        -- end, { desc = 'Reopen window left' })
        -- map_set({ 'n' }, '<leader>L', function()
        --     close_and_open_surround_cb(function() feedkeys('<c-w>L', 'n') end)
        -- end, { desc = 'Reopen window right' })

        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'neo-tree-popup',
            callback = function()
                vim.wo.wrap = false
                -- map_set({ 'n', 'i' }, '<c-n>', function()
                --     if vim.api.nvim_get_mode().mode == 'i' or vim.api.nvim_get_mode().mode == 'I' then
                --         feedkeys('<esc>', 'n')
                --     else
                --         feedkeys('i<c-c>', 'm')
                --     end
                -- end, { buffer = true })
                -- map_set({ 'n', 'i' }, '<esc>', function()
                --     if vim.api.nvim_get_mode().mode == 'i' or vim.api.nvim_get_mode().mode == 'I' then
                --         feedkeys('<esc>', 'n')
                --     else
                --         feedkeys('i<c-c>', 'm')
                --     end
                -- end, { buffer = true })
            end
        })
    end
}
