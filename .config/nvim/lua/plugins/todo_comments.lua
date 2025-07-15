local utils = require('utils')
local comma_semicolon = require('comma_semicolon')
local prev_todo, next_todo = comma_semicolon.make(
    function() require('todo-comments').jump_prev() end,
    function() require('todo-comments').jump_next() end
)
return {
    'folke/todo-comments.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    event = 'VeryLazy',
    opts = {
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
                utils.should_ignore_hidden_files() and nil or '--hidden',
            },
            pattern = [[\b(KEYWORDS):]],
        },
    },
    keys = {
        {
            '<leader>st',
            function()
                if not Snacks then return end
                Snacks.picker.todo_comments({
                    on_show = function() vim.cmd.stopinsert() end,
                    hidden = not utils.should_ignore_hidden_files(),
                })
            end,
            desc = 'Search todo comments',
        },
        { ']t', next_todo, desc = 'Next todo comment', mode = { 'n', 'x', 'o' } },
        { '[t', prev_todo, desc = 'Previous todo comment', mode = { 'n', 'x', 'o' } },
    },
}
