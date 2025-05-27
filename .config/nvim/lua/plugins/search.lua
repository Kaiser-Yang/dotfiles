return {
    'Kaiser-Yang/flash.nvim',
    event = 'VeryLazy',
    branch = 'kaiser-fix-current',
    ---@type Flash.Config
    opts = {
        search = {
            exclude = {
                'notify',
                'cmp_menu',
                'noice',
                'flash_prompt',
                'blink-cmp-menu',
                function(win) return not vim.api.nvim_win_get_config(win).focusable end,
            },
        },
        modes = {
            char = {
                jump_labels = true,
                -- BUG: disable multi_line may cause dot repeat to not work as expected
                multi_line = true,
                char_actions = function()
                    return {
                        [';'] = 'next',
                        [','] = 'prev',
                    }
                end,
                label = {
                    exclude = '',
                },
            },
            search = {
                enabled = true,
                highlight = {
                    backdrop = true,
                },
            },
        },
        jump = {
            nohlsearch = true,
        },
    },
    keys = {
        { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
        {
            'R',
            mode = { 'o', 'x' },
            function() require('flash').treesitter_search() end,
            desc = 'Treesitter Search',
        },
        {
            'S',
            mode = { 'n', 'x', 'o' },
            function() require('flash').treesitter() end,
            desc = 'Flash Treesitter',
        },
        {
            '*',
            mode = { 'n', 'x' },
            function()
                local word = vim.fn.expand('<cword>')
                return '/' .. word
            end,
            desc = 'Flash Search Current Word',
            expr = true,
        },
        {
            '#',
            mode = { 'n', 'x' },
            function()
                local word = vim.fn.expand('<cword>')
                return '?' .. word
            end,
            desc = 'Flash Search Current Word Backward',
            expr = true,
        },
    },
}
