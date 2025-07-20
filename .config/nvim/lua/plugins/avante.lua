local utils = require('utils')
local map_set = utils.map_set
local comma_semicolon = require('comma_semicolon')
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'Avante*',
    callback = function()
        for _, key in pairs({ 'i', 'I', 'a', 'A' }) do
            map_set({ 'n' }, key, function()
                local win = utils.get_win_with_filetype('AvanteInput')
                if win then vim.api.nvim_set_current_win(win) end
                vim.schedule(function()
                    if vim.api.nvim_get_mode().mode ~= 'i' then vim.cmd('normal! i') end
                end)
            end, { buffer = true })
        end
    end,
})
return {
    'yetone/avante.nvim',
    build = 'make',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    event = { { event = 'User', pattern = 'NetworkCheckedOK' } },
    opts = {
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
                switch_windows = '<f31>',
                reverse_switch_windows = '<f32>',
            },
            submit = {
                insert = '<M-CR>',
            },
        },
        selector = {
            provider = 'snacks',
        },
    },
    config = function(_, opts)
        require('avante').setup(opts)
        local diff = require('avante.diff')
        local prev_diff, next_diff = comma_semicolon.make(
            function() diff.find_next('ours') end,
            function() diff.find_prev('ours') end
        )
        map_set({ 'n' }, ']a', next_diff, { buffer = true, desc = 'Next avante diff' })
        map_set({ 'n' }, '[a', prev_diff, { buffer = true, desc = 'Previous avante diff' })
    end,
}
