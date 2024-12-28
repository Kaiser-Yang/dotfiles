return {
    'nvimdev/lspsaga.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
        'catppuccin/nvim'
    },
    event = 'LspAttach',
    config = function()
        require('lspsaga').setup({
            ui = {
                kind = require('catppuccin.groups.integrations.lsp_saga').custom_kind(),
            },
            outline = {
                win_position = 'right',
                win_width = 40,
                keys = {
                    jump = '<cr>',
                    toggle_or_jump = 'o',
                    quit = { 'q' }
                }
            },
            code_action = {
                extend_gitsigns = true,
                keys = {
                    quit = { 'q', '<esc>', '<c-n>' },
                    exec = '<cr>'
                }
            },
            diagnostic = {
                keys = {
                    quit = { 'q', '<esc>', '<c-n>' },
                    quit_in_show = { 'q', '<esc>', '<c-n>' },
                }
            },
            hover = {
                open_cmd = '!wslview'
            },
            rename = {
                in_select = false,
                keys = {
                    quit = { '<esc>' }
                }
            },
            lightbulb = {
                enable = false,
            },
        })
        local map_set = require('utils').map_set
        local feedkeys = require('utils').feedkeys
        map_set({ 'n' }, 'gr', '<cmd>silent Telescope lsp_references<cr>',
            { desc = 'Go references' })
        map_set({ 'n' }, 'gd', '<cmd>silent Lspsaga goto_definition<cr>',
            { desc = 'Go to definition' })
        map_set({ 'n' }, '<leader>d', '<cmd>silent Lspsaga hover_doc<cr>',
            { desc = 'Hover document' })
        map_set({ 'n' }, '<leader>R', '<cmd>silent Lspsaga rename mode=n<cr>',
            { desc = 'Rename' })
        map_set({ 'n' }, 'gi', '<cmd>silent Lspsaga finder imp<cr>',
            { desc = 'Go to implementations' })
        map_set({ 'n', 'x' }, 'ga', '<cmd>silent Lspsaga code_action<cr>',
            { desc = 'Code action' })
        map_set({ 'n', 'i' }, '<c-w>', function()
            vim.cmd('silent Lspsaga outline')
            local mode = vim.api.nvim_get_mode().mode;
            local filetype = vim.o.filetype
            if filetype == 'sagaoutline' and (mode == 'i' or mode == 'I') then
                feedkeys('<esc>', 'n')
            end
        end)
        local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
        local next_diagnostic_repeat, prev_diagnostic_repeat = ts_repeat_move.make_repeatable_move_pair(
            function()
                vim.cmd('silent Lspsaga diagnostic_jump_next')
            end,
            function()
                vim.cmd('silent Lspsaga diagnostic_jump_prev')
            end)
        map_set({ 'n' }, ']d', next_diagnostic_repeat,
            { desc = 'Next diagnostic' })
        map_set({ 'n' }, '[d', prev_diagnostic_repeat,
            { desc = 'Previous diagnostic' })
    end,
}
