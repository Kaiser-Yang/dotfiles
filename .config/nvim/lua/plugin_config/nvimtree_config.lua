local function nvimtree_on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
        return {
            desc = 'nvim-tree: ' .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true
        }
    end

    function EnterOnNvimTreeNode()
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

    function NodeSelect()
        local node = api.tree.get_node_under_cursor()
        if node == nil then
            return
        end
        api.node.open.edit(node)
    end

    function NodeCollapse()
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

    vim.cmd [[
    setlocal splitright
    ]]
    vim.keymap.set({ 'n' }, 'a', api.fs.create, opts('Create File or Directory'))
    vim.keymap.set({ 'n' }, 'c', api.fs.copy.node, opts('Copy'))
    vim.keymap.set({ 'n' }, 'x', api.fs.cut, opts('Cut'))
    vim.keymap.set({ 'n' }, 'p', api.fs.paste, opts('Paste'))
    vim.keymap.set({ 'n' }, 'y', api.fs.copy.filename, opts('Copy Name'))
    vim.keymap.set({ 'n' }, 'd', api.fs.remove, opts('Delete'))
    vim.keymap.set({ 'n' }, 'r', api.fs.rename, opts('Rename'))
    vim.keymap.set({ 'n' }, 'R', api.fs.rename_full, opts('Rename: Full Path'))

    vim.keymap.set({ 'n' }, '[g', api.node.navigate.git.prev, opts('Prev Git'))
    vim.keymap.set({ 'n' }, ']g', api.node.navigate.git.next, opts('Next Git'))
    vim.keymap.set({ 'n' }, ']d', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
    vim.keymap.set({ 'n' }, '[d', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))

    vim.keymap.set({ 'n' }, '<leader>l', api.node.open.vertical, opts('Open: Vertical Split'))
    vim.keymap.set({ 'n' }, '<leader>j', api.node.open.horizontal, opts('Open: Horizontal Split'))
    vim.keymap.set({ 'n' }, '<2-LeftMouse>', api.node.open.edit, opts('Open'))

    vim.keymap.set({ 'n' }, '?', api.tree.toggle_help, opts('Help'))
    vim.keymap.set({ 'n' }, '<c-e>', api.tree.toggle, opts('Toggle'))
    vim.keymap.set({ 'n' }, '<f5>', api.tree.reload, opts('Refresh'))
    vim.keymap.set({ 'n' }, '<bs>', api.tree.change_root_to_parent, opts('Up'))
    vim.keymap.set({ 'n' }, '<cr>', EnterOnNvimTreeNode, opts('Enter Folder or Open File'))
    vim.keymap.set({ 'n' }, 'h', NodeCollapse, opts('Collapse Folder'))
    vim.keymap.set({ 'n' }, 'l', NodeSelect, opts('Toggle Folder or Open File'))

    -- vim.keymap.set({ 'n' }, '<leader>t', '<cmd>lua require("nvim-tree.api").node.open.tab()<cr><cmd>lua ToggleTermOnTabEnter()<cr>', opts('Open: New Tab'))
end

require("nvim-tree").setup({
    auto_reload_on_write = true,
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 35,
        number = true,
        relativenumber = true,
        -- when false, will let all the new windows have the same size
        -- reserve_window_proportions = true, -- cmake-tools say that they need this
    },
    tab = {
        sync = {
            open = true,
            close = false,
            ignore = {},
        },
    },
    on_attach = nvimtree_on_attach,
})
-- Use the parser of markdown to parse the vimwiki files
vim.treesitter.language.register('markdown', 'vimwiki')

-- local map = require'archvim/mappings'
