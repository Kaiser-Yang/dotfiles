local utils = require('utils')
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'Avante*',
    callback = function()
        for _, key in pairs({ 'i', 'I', 'a', 'A', 'o', 'O' }) do
            utils.map_set({ 'n' }, key, function()
                local win = utils.get_win_with_filetype('AvanteInput')[1]
                if win and win ~= vim.api.nvim_get_current_win() then
                    vim.api.nvim_set_current_win(win)
                    vim.schedule(function()
                        if vim.api.nvim_get_mode().mode ~= 'i' then vim.cmd('normal! i') end
                    end)
                else
                    vim.cmd('normal! i')
                end
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
        'zbirenbaum/copilot.lua',
    },
    event = { { event = 'User', pattern = 'NetworkCheckedOK' } },
    opts = {
        provider = 'copilot',
        autosuggestion_provider = 'copilot',
        mappings = {
            suggestion = {
                accept = '<m-cr>',
                dismiss = '<c-c>',
                next = '<c-j>',
                prev = '<c-k>',
            },
            submit = {
                insert = '<M-CR>',
            },
        },
        selector = {
            provider = 'snacks',
        },
    },
}
