return {
    'akinsho/git-conflict.nvim',
    version = "*",
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    config = function()
        local git_conflict = require('git-conflict')
        ---@diagnostic disable-next-line: missing-fields
        git_conflict.setup({
            default_mappings = false,
            disable_diagnostics = true,
        })
        local map_set = require('utils').map_set
        local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
        local next_conflict_repeat, prev_conflict_repeat = ts_repeat_move.make_repeatable_move_pair(
            git_conflict.next_conflict,
            git_conflict.prev_conflict)
        map_set({ 'n' }, ']x', next_conflict_repeat,
            { desc = 'Next git conflict' })
        map_set({ 'n' }, '[x', prev_conflict_repeat,
            { desc = 'Previous git conflict' })
        map_set({ 'n' }, 'gcc', '<plug>(git-conflict-ours)',
            { desc = 'Git keep current' })
        map_set({ 'n' }, 'gci', '<plug>(git-conflict-theris)',
            { desc = 'Git keep incomming' })
        map_set({ 'n' }, 'gcb', '<plug>(git-conflict-both)',
            { desc = 'Git keep both' })
        map_set({ 'n' }, 'gcn', '<plug>(git-conflict-none)',
            { desc = 'Git keep none' })
    end
}
