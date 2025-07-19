local comma_semicolon = require('comma_semicolon')
local prev_word, next_word = comma_semicolon.make(
    function() require('non-ascii').b() end,
    function() require('non-ascii').w() end
)
local prev_end_word, next_end_word = comma_semicolon.make(
    function() require('non-ascii').ge() end,
    function() require('non-ascii').e() end
)
return {
    'Kaiser-Yang/non-ascii.nvim',
    opts = {
        word = {
            word_files = { vim.fn.expand('~/.config/nvim/dict/zh_dict.txt') },
        },
    },
    keys = {
        {
            'iw',
            function() require('non-ascii').iw() end,
            mode = { 'x', 'o' },
            desc = 'Inside a word',
        },
        {
            'aw',
            function() require('non-ascii').aw() end,
            mode = { 'x', 'o' },
            desc = 'Around a word',
        },
        { 'b', prev_word, mode = { 'n', 'x' }, desc = 'Previous word' },
        { 'w', next_word, mode = { 'n', 'x' }, desc = 'Next word' },
        { 'ge', prev_end_word, mode = { 'n', 'x' }, desc = 'Previous end word' },
        { 'e', next_end_word, mode = { 'n', 'x' }, desc = 'Next end word' },
        { 'b', function() require('non-ascii').b() end, mode = 'o', desc = 'Previous word' },
        { 'w', function() require('non-ascii').w() end, mode = 'o', desc = 'Next word' },
        {
            'ge',
            function() require('non-ascii').ge() end,
            mode = 'o',
            desc = 'Previous end word',
        },
        { 'e', function() require('non-ascii').e() end, mode = 'o', desc = 'Next end word' },
    },
}
