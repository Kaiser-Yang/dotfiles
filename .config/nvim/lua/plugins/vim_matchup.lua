local comma_semicolon = require('comma_semicolon')
local prev_matchup, next_matchup = comma_semicolon.make('<plug>(matchup-g%)', '<plug>(matchup-%)')
local prev_multi_matchup, next_multi_matchup =
    comma_semicolon.make('<plug>(matchup-[%)', '<plug>(matchup-][%)')
local prev_inner_matchup, next_inner_matchup =
    comma_semicolon.make('<plug>(matchup-z%)', '<plug>(matchup-Z%)')
require('utils').map_set_all({
    {
        { 'n', 'x' },
        'g%',
        prev_matchup,
        { desc = 'Previous matchup', expr = true },
    },
    {
        { 'n', 'x' },
        '%',
        next_matchup,
        { desc = 'Next matchup', expr = true },
    },
    {
        { 'n', 'x' },
        '[%',
        prev_multi_matchup,
        { desc = 'Previous multi matchup', expr = true },
    },
    {
        { 'n', 'x' },
        '][%',
        next_multi_matchup,
        { desc = 'Next multi matchup', expr = true },
    },
    {
        { 'n', 'x' },
        'z%',
        prev_inner_matchup,
        { desc = 'Previous inner matchup', expr = true },
    },
    {
        { 'n', 'x' },
        'Z%',
        next_inner_matchup,
        { desc = 'Next inner matchup', expr = true },
    },
})
return {
    'andymass/vim-matchup',
    config = true,
}
