return {
    'nvimdev/lspsaga.nvim',
    dependencies = {
        -- 'nvim-treesitter/nvim-treesitter',
        -- 'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-tree/nvim-web-devicons',
        'catppuccin/nvim',
    },
    event = 'LspAttach',
    config = function()
        require('lspsaga').setup({
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
            ui = {
                kind = require('catppuccin.groups.integrations.lsp_saga').custom_kind(),
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
                sign = false,
                virtual_text = true,
            },
        })
        local map_set = require('utils').map_set
        local feedkeys = require('utils').feedkeys
        map_set({ 'n' }, 'gd', '<cmd>Lspsaga goto_definition<cr>', { desc = 'Go to definition' })
        map_set(
            { 'n' },
            'gt',
            '<cmd>Lspsaga goto_type_definition<cr>',
            { desc = 'Go to type definition' }
        )
        map_set({ 'n' }, 'gi', '<cmd>Lspsaga finder imp<cr>', { desc = 'Go to implementations' })
        map_set({ 'n' }, 'gr', '<cmd>Lspsaga finder ref<cr>', { desc = 'Go references' })
        map_set(
            { 'n' },
            '<leader>i',
            '<cmd>Lspsaga incoming_calls<cr>',
            { desc = 'Incoming calls' }
        )
        map_set(
            { 'n' },
            '<leader>o',
            '<cmd>Lspsaga outgoing_calls<cr>',
            { desc = 'Outgoing calls' }
        )
        map_set({ 'n' }, '<leader>R', '<cmd>Lspsaga rename mode=n<cr>', { desc = 'Rename' })
        local next_diagnostic_repeat, prev_diagnostic_repeat = require(
            'nvim-treesitter.textobjects.repeatable_move'
        ).make_repeatable_move_pair(
            function() vim.cmd('silent Lspsaga diagnostic_jump_next') end,
            function() vim.cmd('silent Lspsaga diagnostic_jump_prev') end
        )
        map_set({ 'n' }, ']d', next_diagnostic_repeat, { desc = 'Next diagnostic' })
        map_set({ 'n' }, '[d', prev_diagnostic_repeat, { desc = 'Previous diagnostic' })
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'sagarename',
            callback = function()
                map_set({ 'i', 'n' }, '<esc>', function()
                    if
                        vim.api.nvim_get_mode().mode == 'i'
                        or vim.api.nvim_get_mode().mode == 'I'
                    then
                        feedkeys('<esc>', 'n')
                    else
                        feedkeys('<c-c>', 'm')
                    end
                end, { buffer = true })
            end,
        })
    end,
}
