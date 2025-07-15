local comma_semicolon = require('comma_semicolon')
local prev_conflict, next_conflict =
    comma_semicolon.make('<plug>(git-conflict-prev-conflict)', '<plug>(git-conflict-next-conflict)')
return {
    'akinsho/git-conflict.nvim',
    version = '*',
    event = 'VeryLazy',
    opts = {
        default_mappings = false,
        disable_diagnostics = true,
    },
    keys = {
        { 'gcc', '<plug>(git-conflict-ours)', desc = 'Git keep current' },
        { 'gci', '<plug>(git-conflict-theirs)', desc = 'Git keep incomming' },
        { 'gcb', '<plug>(git-conflict-both)', desc = 'Git keep both' },
        { 'gcn', '<plug>(git-conflict-none)', desc = 'Git keep none' },
        { ']x', next_conflict, desc = 'Next git conflict', expr = true, mode = { 'n', 'x', 'o' } },
        { '[x', prev_conflict, desc = 'Prev git conflict', expr = true, mode = { 'n', 'x', 'o' } },
    },
}
