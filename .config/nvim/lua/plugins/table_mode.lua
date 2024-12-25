return {
    'dhruvasagar/vim-table-mode',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    ft = vim.g.markdown_support_filetype,
    init = function()
        vim.g.table_mode_motion_up_map = ''
        vim.g.table_mode_motion_down_map = ''
        local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
        local map_set = require('utils').map_set
        local feedkeys = require('utils').feedkeys
        -- Enable table mode for markdown file
        vim.api.nvim_create_autocmd('FileType', {
            group = 'UserDIY',
            pattern = vim.g.markdown_support_filetype,
            callback = function()
                vim.cmd('silent TableModeEnable')
                local right_item, left_item = ts_repeat_move.make_repeatable_move_pair(
                    function() feedkeys('<plug>(table-mode-motion-right)', 'n') end,
                    function() feedkeys('<plug>(table-mode-motion-left)', 'n') end)
                map_set({ 'n', 'x', 'o' }, ']|', right_item, { buffer = true })
                map_set({ 'n', 'x', 'o' }, '[|', left_item, { buffer = true })
            end
        })
    end
}
