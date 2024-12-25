return {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
        local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
        local nvim_tree = require('nvim-tree')
        local api = require('nvim-tree.api')
        local map_set = require('utils').map_set
        local function nvimtree_on_attach(bufnr)
            local function opts(desc)
                return {
                    silent = true,
                    noremap = true,
                    desc = 'nvim-tree: ' .. desc,
                    buffer = bufnr,
                    nowait = true
                }
            end
            local function enter_current_node()
                local node = api.tree.get_node_under_cursor()
                if node == nil then
                    return
                end
                if vim.fn.isdirectory(node.absolute_path) == 1 then
                    api.tree.change_root_to_node(node)
                else
                    api.node.open.edit(node)
                end
            end

            local function toggle_or_open_node()
                local node = api.tree.get_node_under_cursor()
                if node == nil then
                    return
                end
                api.node.open.edit(node)
            end

            local function collapse_or_to_parent()
                local node = api.tree.get_node_under_cursor()
                if node == nil then
                    return
                end
                if vim.fn.isdirectory(node.absolute_path) == 1 then
                    if not node.open then
                        api.node.navigate.parent(node)
                    else
                        api.node.open.edit(node)
                    end
                else
                    api.node.navigate.parent(node)
                end
            end

            vim.cmd('setlocal splitright')
            map_set({ 'n' }, 'a', api.fs.create, opts('Create File or Directory'))
            map_set({ 'n' }, 'c', api.fs.copy.node, opts('Copy'))
            map_set({ 'n' }, 'x', api.fs.cut, opts('Cut'))
            map_set({ 'n' }, 'p', api.fs.paste, opts('Paste'))
            map_set({ 'n' }, 'y', api.fs.copy.filename, opts('Copy Name'))
            map_set({ 'n' }, 'd', api.fs.remove, opts('Delete'))
            map_set({ 'n' }, 'r', api.fs.rename, opts('Rename'))
            map_set({ 'n' }, 'H', api.tree.collapse_all, opts('Collapse All'))
            map_set({ 'n' }, 'L', api.tree.expand_all, opts('Expand All'))
            map_set({ 'n' }, 'R', api.fs.rename_full, opts('Rename: Full Path'))

            local next_git_repeat, prev_git_repeat = ts_repeat_move.make_repeatable_move_pair(
                api.node.navigate.git.next,
                api.node.navigate.git.prev)
            local next_diagnostic_repeat, prev_diagnostic_repeat = ts_repeat_move.make_repeatable_move_pair(
                api.node.navigate.diagnostics.next,
                api.node.navigate.diagnostics.prev)
            map_set({ 'n' }, ']g', next_git_repeat, opts('Next Git'))
            map_set({ 'n' }, '[g', prev_git_repeat, opts('Prev Git'))
            map_set({ 'n' }, ']d', next_diagnostic_repeat, opts('Next Diagnostic'))
            map_set({ 'n' }, '[d', prev_diagnostic_repeat, opts('Prev Diagnostic'))

            map_set({ 'n' }, '<leader>l', api.node.open.vertical, opts('Open: Vertical Split'))
            map_set({ 'n' }, '<leader>j', api.node.open.horizontal, opts('Open: Horizontal Split'))
            map_set({ 'n' }, '<2-LeftMouse>', api.node.open.edit, opts('Open'))

            map_set({ 'n' }, '?', api.tree.toggle_help, opts('Help'))
            map_set({ 'n' }, '<c-e>', api.tree.toggle, opts('Toggle'))
            map_set({ 'n' }, '<f5>', api.tree.reload, opts('Refresh'))
            map_set({ 'n' }, '<bs>', api.tree.change_root_to_parent, opts('Directory Up'))
            map_set({ 'n' }, '<cr>', enter_current_node, opts('Enter Folder or Open File'))
            map_set({ 'n' }, 'h', collapse_or_to_parent, opts('Collapse Folder or Go to Parent'))
            map_set({ 'n' }, 'l', toggle_or_open_node, opts('Toggle Folder or Open File'))
        end
        nvim_tree.setup({
            disable_netrw = true,
            reload_on_bufenter = true,
            sort = {
                sorter = "case_sensitive",
            },
            view = {
                width = '15%',
                number = true,
                relativenumber = true,
            },
            update_focused_file = {
                enable = true,
            },
            filters = {
                git_ignored = false,
            },
            on_attach = nvimtree_on_attach,
        })
        local feedkeys = require('utils').feedkeys
        map_set({ 'n', 'i' }, '<c-e>', function()
            api.tree.toggle({
                path = require('utils').get_root_directory(),
            })
            local mode = vim.api.nvim_get_mode().mode;
            if api.tree.is_tree_buf() and (mode == 'i' or mode == 'I') then
                feedkeys('<esc>', 'n')
            end
        end)
        local function close_and_open_surround_cb(cb)
            local visible = api.tree.is_visible()
            if visible then
                api.tree.toggle()
            end
            cb()
            if visible then
                vim.schedule(function()
                    api.tree.toggle({
                        cwd = require('utils').get_root_directory(),
                        focus = false,
                    })
                end)
            end
        end
        map_set({ 'n' }, '<leader>J', function()
            close_and_open_surround_cb(function() feedkeys('<c-w>J', 'n') end)
        end, { desc = 'Reopen window down' })
        map_set({ 'n' }, '<leader>K', function()
            close_and_open_surround_cb(function() feedkeys('<c-w>K', 'n') end)
        end, { desc = 'Reopen window up' })
        map_set({ 'n' }, '<leader>H', function()
            close_and_open_surround_cb(function() feedkeys('<c-w>H', 'n') end)
        end, { desc = 'Reopen window left' })
        map_set({ 'n' }, '<leader>L', function()
            close_and_open_surround_cb(function() feedkeys('<c-w>L', 'n') end)
        end, { desc = 'Reopen window right' })
    end,
}
