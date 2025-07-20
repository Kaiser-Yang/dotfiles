local comma_semicolon = require('comma_semicolon')
local prev_matchup, next_matchup = comma_semicolon.make('<plug>(matchup-g%)', '<plug>(matchup-%)')
local prev_multi_matchup, next_multi_matchup =
    comma_semicolon.make('<plug>(matchup-[%)', '<plug>(matchup-][%)')
local prev_inner_matchup, next_inner_matchup =
    comma_semicolon.make('<plug>(matchup-z%)', '<plug>(matchup-Z%)')
vim.api.nvim_create_autocmd('BufEnter', {
    group = 'UserDIY',
    callback = function()
        -- only highlight the (), [], and {}
        vim.b.matchup_matchparen_enabled = 0
    end,
})
return {
    'andymass/vim-matchup',
    -- NOTE:
    -- We can not lazy load this plugin,
    -- otherwise there may be some problems when first usinng the keys
    lazy = false,
    keys = {
        {
            'g%',
            prev_matchup,
            expr = true,
            mode = { 'n', 'x' },
            desc = 'Previous matchup',
        },
        {
            '%',
            next_matchup,
            expr = true,
            mode = { 'n', 'x' },
            desc = 'Next matchup',
        },
        {
            '[%',
            prev_multi_matchup,
            expr = true,
            mode = { 'n', 'x' },
            desc = 'Previous multi matchup',
        },
        {
            '][%',
            next_multi_matchup,
            mode = { 'n', 'x' },
            expr = true,
            desc = 'Next multi matchup',
        },
        {
            'z%',
            prev_inner_matchup,
            expr = true,
            mode = { 'n', 'x' },
            desc = 'Previous inner matchup',
        },
        {
            'Z%',
            next_inner_matchup,
            expr = true,
            mode = { 'n', 'x' },
            desc = 'Next inner matchup',
        },
    },
}
