return {
    'Kaiser-Yang/non-ascii.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    opts = {
        word = {
            word_files = { vim.fn.expand('~/.config/nvim/dict/zh_dict.txt') },
        }
    },
    config = function(_, opts)
        local non_ascii= require('non-ascii')
        non_ascii.setup(opts)
        local map_set = require('utils').map_set
        local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
        local next_word, prev_word = ts_repeat_move.make_repeatable_move_pair(
            non_ascii.w,
            non_ascii.b
        )
        local next_end_word, prev_end_word = ts_repeat_move.make_repeatable_move_pair(
            non_ascii.e,
            non_ascii.ge
        )
        map_set({ 'n', 'x' }, 'w', next_word, { desc = 'Next word' })
        map_set({ 'n', 'x' }, 'w', next_word, { desc = 'Next word' })
        map_set({ 'n', 'x' }, 'b', prev_word, { desc = 'Previous word' })
        map_set({ 'n', 'x' }, 'e', next_end_word, { desc = 'Next end word' })
        map_set({ 'n', 'x' }, 'ge', prev_end_word, { desc = 'Previous end word' })
        map_set('o', 'w', non_ascii.e, { desc = 'Next word' })
        map_set('o', 'b', non_ascii.b, { desc = 'Previous word' })
        map_set('o', 'e', non_ascii.e, { desc = 'Next end word' })
        map_set('o', 'ge', non_ascii.ge, { desc = 'Previous end word' })
        map_set({ 'x', 'o' }, 'iw', non_ascii.iw, { desc = 'Inside a word' })
        map_set({ 'x', 'o' }, 'aw', non_ascii.aw, { desc = 'Around a word' })
    end,
}
