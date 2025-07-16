return {
    'gbprod/yanky.nvim',
    opts = {
        system_clipboard = {
            clipboard_registore = '+',
        },
        picker = {
            -- TODO:
            -- Only highlight when the content is small or only hight current view
            highlight = {
                on_yank = true,
                on_put = true,
                timer = 50,
            },
        },
    },
    keys = {
        { mode = { 'n', 'x' }, 'y', '<plug>(YankyYank)' },
        { mode = { 'n', 'x' }, 'p', '<plug>(YankyPutAfter)' },
        { mode = { 'n', 'x' }, 'P', '<plug>(YankyPutBefore)' },
        { mode = { 'n', 'x' }, 'gp', '<plug>(YankyGPutAfter)' },
        { mode = { 'n', 'x' }, 'gP', '<plug>(YankyGPutBefore)' },
        {
            mode = { 'n', 'x' },
            'gy',
            function()
                if not Snacks then return end
                Snacks.picker.yanky({
                    on_show = function() vim.cmd.stopinsert() end,
                })
            end,
        },
    },
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
}
