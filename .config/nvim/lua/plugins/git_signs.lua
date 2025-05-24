return {
    'lewis6991/gitsigns.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {
        current_line_blame = true,
        current_line_blame_opts = {
            delay = 100,
        },
        on_attach = function(bufnr)
            local gs = require('gitsigns')
            local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
            local map_set = require('utils').map_set
            local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(
                function() gs.nav_hunk('next') end,
                function() gs.nav_hunk('prev') end
            )
            map_set(
                { 'n', 'x', 'o' },
                ']g',
                next_hunk_repeat,
                { desc = 'Next git hunk', buffer = bufnr }
            )
            map_set(
                { 'n', 'x', 'o' },
                '[g',
                prev_hunk_repeat,
                { desc = 'Previous git hunk', buffer = bufnr }
            )
            map_set(
                { 'n' },
                'gcu',
                gs.reset_hunk,
                { desc = 'Git reset current hunk', buffer = bufnr }
            )
            map_set(
                { 'n' },
                'gcd',
                gs.preview_hunk,
                { desc = 'Git diff current hunk', buffer = bufnr }
            )
        end,
    },
}
