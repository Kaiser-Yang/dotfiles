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
                'neo-tree',
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
                jump = {
                    do_first_jump = false,
                },
            },
            search = {
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
            '<c-s>',
            mode = { 'n', 'x', 'o' },
            function() require('flash').treesitter() end,
            desc = 'Flash Treesitter',
        },
        {
            '*',
            mode = { 'n', 'x', 'o' },
            function()
                local word = vim.fn.expand('<cword>')
                require('flash').jump({
                    search = {
                        forward = true,
                        wrap = false,
                        multi_window = false,
                    },
                    pattern = word,
                })
            end,
            desc = 'Flash Search Current Word',
        },
        {
            '#',
            mode = { 'n', 'x', 'o' },
            function()
                local word = vim.fn.expand('<cword>')
                require('flash').jump({
                    search = {
                        forward = false,
                        wrap = false,
                        multi_window = false,
                    },
                    pattern = word,
                })
            end,
            desc = 'Flash Search Current Word Backward',
        },
        {
            's',
            mode = { 'n', 'x' },
            function()
                local flash = require('flash')
                ---@param opts Flash.Format
                local function format(opts)
                    -- always show first and second label
                    return {
                        { opts.match.label1, 'FlashMatch' },
                        { opts.match.label2, 'FlashLabel' },
                    }
                end
                flash.jump({
                    search = { mode = 'search' },
                    label = {
                        after = false,
                        before = { 0, 0 },
                        uppercase = false,
                        format = format,
                    },
                    pattern = [[\<]],
                    action = function(match, state)
                        state:hide()
                        flash.jump({
                            search = { max_length = 0 },
                            highlight = { matches = false },
                            label = { format = format },
                            matcher = function(win)
                                -- limit matches to the current label
                                return vim.tbl_filter(
                                    function(m) return m.label == match.label and m.win == win end,
                                    state.results
                                )
                            end,
                            labeler = function(matches)
                                for _, m in ipairs(matches) do
                                    m.label = m.label2 -- use the second label
                                end
                            end,
                        })
                    end,
                    labeler = function(matches, state)
                        local labels = state:labels()
                        for m, match in ipairs(matches) do
                            match.label1 = labels[math.floor((m - 1) / #labels) + 1]
                            match.label2 = labels[(m - 1) % #labels + 1]
                            match.label = match.label1
                        end
                    end,
                })
            end,
            desc = 'Flash Search Two Characters',
        },
    },
}
