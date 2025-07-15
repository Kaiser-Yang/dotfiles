local comma_semicolon = require('comma_semicolon')
local prev_hunk, next_hunk = comma_semicolon.make(
    function() require('gitsigns').nav_hunk('prev') end,
    function() require('gitsigns').nav_hunk('next') end
)
return {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
        current_line_blame = true,
        current_line_blame_opts = {
            delay = 300,
        },
        preview_config = {
            border = 'rounded',
        },
    },
    keys = {
        {
            'gcu',
            function() require('gitsigns').reset_hunk() end,
            desc = 'Git reset current hunk',
        },
        {
            'gcd',
            function() require('gitsigns').preview_hunk() end,
            desc = 'Git diff current hunk',
        },
        {
            'gcs',
            function() require('gitsigns').blame_line({ full = true }) end,
            desc = 'Git blame current line',
        },
        {
            '[g',
            prev_hunk,
            desc = 'Previous git hunk',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']g',
            next_hunk,
            desc = 'Next git hunk',
            mode = { 'n', 'x', 'o' },
        },
    },
}
