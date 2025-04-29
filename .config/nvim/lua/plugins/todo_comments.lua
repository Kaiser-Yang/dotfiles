return {
    'folke/todo-comments.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter-textobjects',
        'folke/snacks.nvim',
    },
    config = function()
        local todo_comments = require('todo-comments')
        todo_comments.setup({
            sign_priority = 1,
            highlight = {
                multiline = false,
            },
            search = {
                command = 'rg',
                args = {
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--hidden',
                },
                pattern = [[\b(KEYWORDS):]],
            },
        })
        local map_set = require('utils').map_set
        local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
        local next_todo, prev_todo = ts_repeat_move.make_repeatable_move_pair(
            todo_comments.jump_next,
            todo_comments.jump_prev
        )
        map_set({ 'n', 'x', 'o' }, ']t', next_todo, { desc = 'Next todo comment' })
        map_set({ 'n', 'x', 'o' }, '[t', prev_todo, { desc = 'Previous todo comment' })
        map_set(
            { 'n' },
            '<leader>st',
            function() Snacks.picker.todo_comments() end,
            { desc = 'Search todo comments' }
        )
    end,
}
