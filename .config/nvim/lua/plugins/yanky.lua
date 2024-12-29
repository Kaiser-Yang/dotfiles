return {
    'gbprod/yanky.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        local map_set = require('utils').map_set
        require('yanky').setup({
            system_clipboard = {
                clipboard_registore = '+'
            },
            picker = {
                highlight = {
                    on_yank = true,
                    on_put = true,
                    timer = 50
                },
            }
        })
        map_set({ 'n', 'x' }, 'y', '<plug>(YankyYank)')
        map_set({ 'n', 'x' }, 'p', '<plug>(YankyPutAfter)')
        map_set({ 'n', 'x' }, 'P', '<plug>(YankyPutBefore)')
        map_set({ 'n', 'x' }, 'gp', '<plug>(YankyGPutAfter)',
            { desc = 'Put yanked text after cursor and leave the cursor after pasted text' })
        map_set({ 'n', 'x' }, 'gP', '<plug>(YankyGPutBefore)',
            { desc = 'Put yanked text before cursor and leave the cursor after pasted text' })
        require('telescope').load_extension('yank_history')
        map_set({ 'n' }, 'gy', function()
            require('telescope').extensions.yank_history.yank_history({ initial_mode = 'normal' })
        end)
        -- TODO:
        -- map_set({ 'n' }, ']p', '<plug>(YankyPutIndentAfterLinewise)')
        -- map_set({ 'n' }, ']P', '<plug>(YankyPutIndentAfterLinewise)')
        -- map_set({ 'n' }, '[p', '<plug>(YankyPutIndentBeforeLinewise)')
        -- map_set({ 'n' }, '[P', '<plug>(YankyPutIndentBeforeLinewise)')
        -- map_set({ 'n' }, '>p', '<plug>(YankyPutIndentAfterShiftRight)')
        -- map_set({ 'n' }, '<p', '<plug>(YankyPutIndentAfterShiftLeft)')
        -- map_set({ 'n' }, '>P', '<plug>(YankyPutIndentBeforeShiftRight)')
        -- map_set({ 'n' }, '<P', '<plug>(YankyPutIndentBeforeShiftLeft)')
        -- map_set({ 'n' }, '=p', '<plug>(YankyPutAfterFilter)')
        -- map_set({ 'n' }, '=P', '<plug>(YankyPutBeforeFilter)')
        -- map_set('n', '<c-p>', '<plug>(YankyPreviousEntry)')
        -- map_set('n', '<c-n>', '<plug>(YankyNextEntry)')
    end
}
