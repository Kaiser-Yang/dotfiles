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
    keys = {
        { 'gd', '<cmd>Lspsaga goto_definition<cr>', desc = 'Go to definition' },
        { 'gt', '<cmd>Lspsaga goto_type_definition<cr>', desc = 'Go to type definition' },
        -- TODO:
        -- update the finder layout ???
        { 'gi', '<cmd>Lspsaga finder imp<cr>', desc = 'Go to implementations' },
        { 'gr', '<cmd>Lspsaga finder ref<cr>', desc = 'Go references' },
        { '<leader>o', '<cmd>Lspsaga outgoing_calls<cr>', desc = 'Outgoing calls' },
        { '<leader>i', '<cmd>Lspsaga incoming_calls<cr>', desc = 'Incoming calls' },
        { '<leader>R', '<cmd>Lspsaga rename mode=n<cr>', desc = 'Rename' },
        { ']d', next_diagnostic, desc = 'Next diagnostic', expr = true, mode = { 'n', 'x', 'o' } },
        { '[d', prev_diagnostic, desc = 'Prev diagnostic', expr = true, mode = { 'n', 'x', 'o' } },
    },
    config = function(_, opts)
        opts.ui = { kind = require('catppuccin.groups.integrations.lsp_saga').custom_kind() }
        require('lspsaga').setup(opts)
    end,
}
