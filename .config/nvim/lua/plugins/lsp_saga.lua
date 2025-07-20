local map_set_all = require('utils').map_set_all
local map_set = require('utils').map_set
local feedkeys = require('utils').feedkeys
local comma_semicolon = require('comma_semicolon')
local prev_diagnostic, next_diagnostic = comma_semicolon.make(
    '<cmd>Lspsaga diagnostic_jump_prev<cr>',
    '<cmd>Lspsaga diagnostic_jump_next<cr>'
)
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'sagarename',
    callback = function()
        map_set({ 'i', 'n' }, '<esc>', function()
            if vim.api.nvim_get_mode().mode == 'i' then
                feedkeys('<esc>', 'n')
            else
                feedkeys('<c-c>', 'm')
            end
        end, { buffer = true })
    end,
})
local lsp_keys = {
    { 'n', 'gd', '<cmd>Lspsaga goto_definition<cr>', { desc = 'Go to definition' } },
    { 'n', 'gt', '<cmd>Lspsaga goto_type_definition<cr>', { desc = 'Go to type definition' } },
    { 'n', 'gi', '<cmd>Lspsaga finder imp<cr>', { desc = 'Go to implementations' } },
    { 'n', 'gr', '<cmd>Lspsaga finder ref<cr>', { desc = 'Go references' } },
    { 'n', '<leader>o', '<cmd>Lspsaga outgoing_calls<cr>', { desc = 'Outgoing calls' } },
    { 'n', '<leader>i', '<cmd>Lspsaga incoming_calls<cr>', { desc = 'Incoming calls' } },
    { 'n', '<leader>R', '<cmd>Lspsaga rename mode=n<cr>', { desc = 'Rename' } },
    { { 'n', 'x', 'o' }, ']d', next_diagnostic, { desc = 'Next diagnostic', expr = true } },
    { { 'n', 'x', 'o' }, '[d', prev_diagnostic, { desc = 'Prev diagnostic', expr = true } },
}
vim.api.nvim_create_autocmd('LspAttach', {
    group = 'UserDIY',
    callback = function(args)
        for _, key in ipairs(lsp_keys) do
            key[4].buffer = args.buf
        end
        map_set_all(lsp_keys)
    end,
})
return {
    'nvimdev/lspsaga.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'catppuccin/nvim',
    },
    event = 'LspAttach',
    opts = {
        callhierarchy = {
            keys = {
                edit = { '<cr>' },
                quit = { 'q', '<esc>' },
            },
        },
        definition = {
            keys = {
                quit = { 'q', '<esc>' },
            },
        },
        code_action = {
            keys = {
                quit = { 'q', '<esc>' },
                exec = '<cr>',
            },
        },
        diagnostic = {
            keys = {
                exec_action = '<cr>',
                quit = { 'q', '<esc>' },
                quit_in_show = { 'q', '<esc>' },
            },
        },
        finder = {
            keys = {
                quit = { 'q', '<esc>' },
                shutter = { '<a-w>' },
                split = { 's', '<c-s>', '<leader>j', '<leader>k' },
                vsplit = { 'v', '<c-v>', '<leader>l', '<leader>h' },
                toggle_or_open = { 'o', '<cr>' },
            },
        },
        rename = {
            in_select = false,
            auto_save = true,
            keys = {
                quit = { '<c-c>' },
            },
        },
        lightbulb = {
            enable = false,
        },
    },
    config = function(_, opts)
        local ok, catppuccin_lsp_saga = pcall(require, 'catppuccin.groups.integrations.lsp_saga')
        if ok then opts.ui = { kind = catppuccin_lsp_saga.custom_kind() } end
        require('lspsaga').setup(opts)
    end,
}
