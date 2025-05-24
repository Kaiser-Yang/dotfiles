return {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    build = 'make',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'stevearc/dressing.nvim',
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'nvim-tree/nvim-web-devicons',
        'zbirenbaum/copilot.lua',
        'MeanderingProgrammer/render-markdown.nvim',
        -- 'HakonHarnes/img-clip.nvim',
    },
    config = function()
        require('avante').setup({
            provider = 'copilot',
            autosuggestion_provider = 'copilot',
            mappings = {
                diff = {
                    ours = 'acc',
                    theirs = 'aci',
                    both = 'acb',
                    all_theirs = 'aca',
                    cursor = 'acl',
                },
                suggestion = {
                    accept = '<m-cr>',
                    dismiss = '<c-c>',
                },
                jump = {},
                sidebar = {
                    apply_all = 'A',
                    apply_cursor = 'a',
                    switch_windows = '<f-32>',
                    reverse_switch_windows = '<f-33>',
                },
                submit = {
                    insert = '<M-CR>',
                },
            },
            selector = {
                provider = 'snacks',
            },
        })
        local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
        local diff = require('avante.diff')
        local next_diff, prev_diff = ts_repeat_move.make_repeatable_move_pair(
            function() diff.find_next('ours') end,
            function() diff.find_prev('ours') end
        )
        local map_set = require('utils').map_set
        local get_win = function(filetype)
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                if filetype == vim.bo[vim.api.nvim_win_get_buf(win)].filetype then return win end
            end
            return nil
        end
        local feedkeys = require('utils').feedkeys
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'Avante*',
            callback = function()
                for _, key in pairs({ 'i', 'I', 'a', 'A' }) do
                    map_set({ 'n' }, key, function()
                        local win = get_win('AvanteInput')
                        if win then vim.api.nvim_set_current_win(win) end
                        vim.schedule(function()
                            if vim.api.nvim_get_mode().mode ~= 'i' then feedkeys(key, 'n') end
                        end)
                    end, { buffer = true })
                end
            end,
        })
        map_set({ 'n' }, ']a', next_diff, { buffer = true, desc = 'Next avante diff' })
        map_set({ 'n' }, '[a', prev_diff, { buffer = true, desc = 'Previous avante diff' })
    end,
}
