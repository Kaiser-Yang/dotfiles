return {
    'gbprod/yanky.nvim',
    dependencies = { 'folke/snacks.nvim' },
    config = function()
        local map_set = require('utils').map_set
        require('yanky').setup({
            system_clipboard = {
                clipboard_registore = '+',
            },
            picker = {
                highlight = {
                    on_yank = true,
                    on_put = true,
                    timer = 50,
                },
            },
            ring = {
                permanent_wrapper = require('yanky.wrappers').remove_carriage_return,
            },
        })
        map_set({ 'n', 'x' }, 'y', '<plug>(YankyYank)')
        map_set({ 'n', 'x' }, 'p', '<plug>(YankyPutAfter)')
        map_set({ 'n', 'x' }, 'P', '<plug>(YankyPutBefore)')
        map_set({ 'n', 'x' }, 'gp', '<plug>(YankyGPutAfter)')
        map_set({ 'n', 'x' }, 'gP', '<plug>(YankyGPutBefore)')
        map_set({ 'n', 'x' }, 'gy', function()
            ---@diagnostic disable-next-line: undefined-field
            require('snacks').picker.yanky({ on_show = function() vim.cmd.stopinsert() end })
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
    end,
}
