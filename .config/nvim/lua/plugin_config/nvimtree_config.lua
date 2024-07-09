local function my_on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true,
            nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)

    function EnterOnNvimTreeNode()
        local node = api.tree.get_node_under_cursor()
        if node ~= nil and vim.fn.isdirectory(node.absolute_path) == 1 then
            api.tree.change_root_to_node()
        else
            api.node.open.edit()
        end
    end

    vim.cmd [[
    setlocal splitright
    ]]
    vim.keymap.del({ 'n' }, '<c-v>', { buffer = bufnr })
    vim.keymap.del({ 'n' }, '<c-x>', { buffer = bufnr })
    vim.keymap.del({ 'n' }, '<c-t>', { buffer = bufnr })
    vim.keymap.del({ 'n' }, 'R', { buffer = bufnr })
    vim.keymap.del({ 'n' }, '<tab>', { buffer = bufnr })

    vim.keymap.set({ 'n' }, '<leader>l', api.node.open.vertical, opts('Open: Vertical Split'))
    vim.keymap.set({ 'n' }, '<leader>j', api.node.open.horizontal, opts('Open: Horizontal Split'))
    vim.keymap.set({ 'n' }, '<leader>t', '<cmd>lua require("nvim-tree.api").node.open.tab()<cr><cmd>lua ToggleTermOnTabEnter()<cr>', opts('Open: New Tab'))
    vim.keymap.set({ 'n' }, '<c-e>', api.tree.toggle, opts('Toggle'))
    vim.keymap.set({ 'n' }, '?', api.tree.toggle_help, opts('Help'))
    vim.keymap.set({ 'n' }, '<bs>', api.tree.change_root_to_parent, opts('Up'))
    vim.keymap.set({ 'n' }, '<cr>', EnterOnNvimTreeNode, opts('Enter directory or file'))
    vim.keymap.set({ 'n' }, '<f5>', api.tree.reload, opts('Refresh'))
    vim.keymap.set({ 'n' }, 'R', api.fs.rename_full, opts('Rename: Full Path'))
end

require("nvim-tree").setup({
    auto_reload_on_write = true,
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
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
    on_attach = my_on_attach,
})
-- Use the parser of markdown to parse the vimwiki files
vim.treesitter.language.register('markdown', 'vimwiki')

-- local map = require'archvim/mappings'
