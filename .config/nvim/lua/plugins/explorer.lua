local utils = require('utils')
local map_set = utils.map_set
local feedkeys = utils.feedkeys
local comma_semicolon = require('comma_semicolon')
local prev_git, next_git = comma_semicolon.make(
    function(state) require('neo-tree.sources.filesystem.commands').prev_git_modified(state) end,
    function(state) require('neo-tree.sources.filesystem.commands').next_git_modified(state) end
)

local function on_file_moved(data)
    if not Snacks then return end
    Snacks.rename.on_rename_file(data.source, data.destination)
end

local function move_cursor_to_neo_tree()
    for _, win in pairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'neo-tree' then
            vim.api.nvim_set_current_win(win)
            break
        end
    end
end
local current_file
vim.api.nvim_create_autocmd('BufEnter', {
    callback = function(_)
        if vim.bo.filetype ~= 'neo-tree-popup' then return end
        local current_line = vim.api.nvim_get_current_line()
        if current_line:match('^ y/n: $') then
            map_set({ 'n' }, 'y', 'iy<cr>', { buffer = true })
            map_set({ 'n' }, 'Y', 'iy<cr>', { buffer = true })
            map_set({ 'n' }, 'n', 'in<cr>', { buffer = true })
            map_set({ 'n' }, 'N', 'in<cr>', { buffer = true })
            if vim.api.nvim_get_mode().mode == 'i' then
                feedkeys('<esc>', 'n') -- back to normal
            end
        end
        map_set({ 'n', 'i' }, '<esc>', function()
            if vim.api.nvim_get_mode().mode == 'i' then
                feedkeys('<esc>', 'n') -- back to nromal
            else
                feedkeys('i<c-c>', 'm') -- quit
            end
        end, { buffer = true })
    end,
})
return {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
        {
            's1n7ax/nvim-window-picker',
            version = '2.*',
            opts = {
                hint = 'floating-big-letter',
                filter_rules = {
                    include_current_win = false,
                    autoselect_one = true,
                    bo = {
                        filetype = {
                            'neo-tree',
                            'neo-tree-popup',
                            'notify',
                            'smear-cursor',
                            'snacks_notif',
                        },
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
            },
        },
    },
    opts = {
        sources = {
            'filesystem',
            'git_status',
            'document_symbols',
        },
        source_selector = {
            winbar = true,
            sources = {
                { source = 'git_status' },
                { source = 'document_symbols' },
                { source = 'filesystem' },
            },
        },
        sort_case_insensitive = true,
        use_default_mappings = false,
        default_component_configs = {
            git_status = {
                symbols = {
                    modified = '',
                    renamed = '➜',
                    untracked = '★',
                    ignored = '◌',
                    unstaged = '✗',
                    staged = '✓',
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
            },
        },
        window = {
            width = function() return math.ceil(math.max(40, 0.15 * vim.o.columns)) end,
            mappings = {
                ['e'] = 'toggle_auto_expand_width',
                ['<2-LeftMouse>'] = {
                    function(state)
                        local node = state.tree:get_node()
                        if node.type ~= 'directory' and not node:has_children() then
                            state.commands.open_with_window_picker(state)
                        else
                            state.commands.toggle_node(state)
                        end
                    end,
                    desc = 'Toggle or Open',
                },
                ['<c-c>'] = 'cancel',
                ['<leader>j'] = 'split_with_window_picker',
                ['<leader>k'] = 'split_with_window_picker',
                ['<leader>l'] = 'vsplit_with_window_picker',
                ['<leader>h'] = 'vsplit_with_window_picker',
                ['<c-s>'] = 'split_with_window_picker',
                ['<c-v>'] = 'vsplit_with_window_picker',
                ['v'] = {
                    function(_) feedkeys('V', 'n') end,
                },
                ['H'] = {
                    function(state)
                        local function collapse(u)
                            if u == nil then return end
                            if u:is_expanded() then u:collapse() end
                            for _, v in pairs(state.tree:get_nodes(u:get_id())) do
                                collapse(v)
                            end
                        end
                        local node_under_cursor = state.tree:get_node()
                        if node_under_cursor:is_expanded() then
                            collapse(node_under_cursor)
                        else
                            local parent_id = node_under_cursor:get_parent_id()
                            require('neo-tree.ui.renderer').focus_node(state, parent_id)
                            for _, child in pairs(state.tree:get_nodes(parent_id)) do
                                collapse(child)
                            end
                        end
                        require('neo-tree.ui.renderer').redraw(state)
                    end,
                    desc = 'collapse_all_under_cursor',
                },
                ['L'] = {
                    function(state)
                        local node_under_cursor = state.tree:get_node()
                        if node_under_cursor.type == 'directory' then
                            state.commands.expand_all_nodes(state, node_under_cursor)
                            return
                        end
                        local function expand(u)
                            if u == nil then return end
                            if u:has_children() and not u:is_expanded() then u:expand() end
                            for _, v in pairs(state.tree:get_nodes(u:get_id())) do
                                expand(v)
                            end
                        end
                        expand(node_under_cursor)
                        require('neo-tree.ui.renderer').redraw(state)
                    end,
                    desc = 'expand_all_under_cursor',
                },
                ['<cr>'] = {
                    function(state)
                        local node = state.tree:get_node()
                        if node.type == 'directory' then
                            if state.commands.set_root then state.commands.set_root(state) end
                        else
                            state.commands.open_with_window_picker(state)
                        end
                    end,
                    desc = 'Enter Dir or Open File',
                },
                ['<f5>'] = 'refresh',
                ['?'] = 'show_help',
                ['h'] = {
                    function(state)
                        local node = state.tree:get_node()
                        if node:is_expanded() then
                            state.commands.toggle_node(state)
                        else
                            require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
                        end
                    end,
                    desc = 'Collapse or Go To Parrent',
                },
                ['l'] = {
                    function(state)
                        local node = state.tree:get_node()
                        if node.type ~= 'directory' and not node:has_children() then
                        else
                            state.commands.toggle_node(state)
                        end
                    end,
                    desc = 'Toggle or Open',
                },
            },
        },
        filesystem = {
            window = {
                mappings = {
                    ['a'] = {
                        'add',
                        config = {
                            show_path = 'absolute',
                        },
                    },
                    ['r'] = 'rename',
                    ['m'] = {
                        'move',
                        config = {
                            show_path = 'absolute',
                        },
                    },
                    ['c'] = {
                        'copy',
                        config = {
                            show_path = 'absolute',
                        },
                    },
                    ['<bs>'] = 'navigate_up',
                    ['[g'] = {
                        prev_git,
                        desc = 'Prev Git Modified',
                    },
                    [']g'] = {
                        next_git,
                        desc = 'Next Git Modified',
                    },
                    ['d'] = 'delete',
                    ['y'] = 'copy_to_clipboard',
                    ['x'] = 'cut_to_clipboard',
                    ['p'] = 'paste_from_clipboard',
                    ['o'] = {
                        'show_help',
                        nowait = false,
                        config = { title = 'Order by', prefix_key = 'o' },
                    },
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
            },
            find_args = {
                fd = {
                    '--hidden',
                    '--exclude',
                    '.git',
                    '.root',
                    '*.o',
                    '*.out',
                    '*.exe',
                    '*.png',
                    '*.gif',
                    '*.jpg',
                    '*.so',
                    '*.a',
                    '*.dll',
                    '*.dylib',
                    '*.class',
                    '*.jar',
                    '*.zip',
                    '*.tar.gz',
                },
            },
        },
        git_status = {
            window = {
                mappings = {
                    ['o'] = {
                        'show_help',
                        nowait = false,
                        config = { title = 'Order by', prefix_key = 'o' },
                    },
                    ['oc'] = { 'order_by_created', nowait = false },
                    ['od'] = { 'order_by_diagnostics', nowait = false },
                    ['og'] = { 'order_by_git_status', nowait = false },
                    ['om'] = { 'order_by_modified', nowait = false },
                    ['on'] = { 'order_by_name', nowait = false },
                    ['os'] = { 'order_by_size', nowait = false },
                    ['ot'] = { 'order_by_type', nowait = false },
                },
            },
        },
        document_symbols = {
            renderers = {
                root = {
                    { 'name' },
                },
                symbol = {
                    { 'indent', with_expanders = true },
                    { 'kind_icon', default = '?' },
                    { 'name' },
                    { 'kind_name' },
                },
            },
        },
        renderers = {
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
                            zindex = 40,
                        },
                        {
                            'file_size',
                            zindex = 30,
                        },
                        {
                            'last_modified',
                            zindex = 20,
                        },
                        {
                            'created',
                            zindex = 10,
                        },
                    },
                },
            },
            directory = {
                { 'indent' },
                { 'icon' },
                { 'current_filter' },
                { 'git_status', hide_when_expanded = true },
                { 'name' },
                { 'diagnostics', errors_only = false, hide_when_expanded = true },
                { 'clipboard' },
                {
                    'container',
                    content = {
                        {
                            'symlink_target',
                            highlight = 'NeoTreeSymbolicLinkTarget',
                            zindex = 40,
                        },
                        {
                            'file_size',
                            zindex = 30,
                        },
                        {
                            'last_modified',
                            zindex = 20,
                        },
                        {
                            'created',
                            zindex = 10,
                        },
                    },
                },
            },
        },
    },
    keys = {
        {
            '<c-q>',
            function()
                if vim.bo.filetype ~= 'neo-tree' then current_file = vim.fn.expand('%:p') end
                move_cursor_to_neo_tree()
                require('neo-tree.command').execute({
                    source = 'git_status',
                    reveal = true,
                    reveal_file = current_file,
                })
            end,
            desc = 'Open Git Status and Reveal Current File',
        },
        {
            '<c-e>',
            function()
                if vim.bo.filetype ~= 'neo-tree' then current_file = vim.fn.expand('%:p') end
                move_cursor_to_neo_tree()
                require('neo-tree.command').execute({
                    source = 'filesystem',
                    reveal = true,
                    reveal_file = current_file,
                })
            end,
            desc = 'Open File Explorer and Reveal Current File',
        },
        {
            '<c-w>',
            function()
                move_cursor_to_neo_tree()
                require('neo-tree.command').execute({
                    source = 'document_symbols',
                })
            end,
            desc = 'Open Document Symbols',
        },
    },
    config = function(_, opts)
        local events = require('neo-tree.events')
        opts.event_handlers = {
            {
                event = events.NEO_TREE_BUFFER_ENTER,
                handler = function(_)
                    vim.wo.number = true
                    vim.wo.relativenumber = true
                    vim.wo.colorcolumn = ''
                end,
            },
            {
                event = events.FILE_MOVED,
                handler = on_file_moved,
            },
            {
                event = events.FILE_RENAMED,
                handler = on_file_moved,
            },
            {
                event = events.NEO_TREE_WINDOW_AFTER_OPEN,
                handler = function(_)
                    vim.g.explorer_visible = true
                    vim.cmd('wincmd =')
                end,
            },
            {
                event = events.NEO_TREE_WINDOW_BEFORE_CLOSE,
                handler = function(_) vim.g.explorer_visible = false end,
            },
        }
        require('neo-tree').setup(opts)
    end,
}
