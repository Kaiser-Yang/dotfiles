return {
    'lervag/vimtex',
    init = function()
        vim.g.vimtex_view_method = 'zathura_simple'
        local auto_follow = false
        local function toggle_vimtex_cursor_follow()
            auto_follow = not auto_follow
            if auto_follow then
                vim.api.nvim_create_autocmd('CursorHold', {
                    group = vim.api.nvim_create_augroup('VimtexViewOnCursorHold', { clear = true }),
                    pattern = '*.tex',
                    callback = function()
                        vim.cmd('silent! VimtexView')
                    end,
                })
                print('Vimtex cursor follow enabled')
            else
                -- clear all autocmds in the group
                vim.api.nvim_create_augroup('VimtexViewOnCursorHold', { clear = true })
                print('Vimtex cursor follow disabled')
            end
        end
        local map_set = require('utils').map_set
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'tex',
            callback = function()
                map_set({ 'n' }, '<leader>r', toggle_vimtex_cursor_follow,
                    { silent = false, buffer = true, desc = 'Compile and run' })
            end
        })
    end,
}
