return {
    'Kaiser-Yang/zh.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    opts = {
        word_jump = {
            word_files = { vim.fn.expand('~/.config/nvim/dict/zh_dict.txt') },
        }
    },
    config = function(_, opts)
        local zh = require('zh')
        zh.setup(opts)
        local map_set = require('utils').map_set
        local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
        local next_word, prev_word = ts_repeat_move.make_repeatable_move_pair(
            zh.w,
            zh.b
        )
        local next_end_word, prev_end_word = ts_repeat_move.make_repeatable_move_pair(
            zh.e,
            zh.ge
        )
        map_set({ 'n', 'x', 'o' }, 'w', next_word, { desc = 'Next word' })
        map_set({ 'n', 'x', 'o' }, 'b', prev_word, { desc = 'Previous word' })
        map_set({ 'n', 'x', 'o' }, 'e', next_end_word, { desc = 'Next end word' })
        map_set({ 'n', 'x', 'o' }, 'ge', prev_end_word, { desc = 'Previous end word' })
    end,
}
