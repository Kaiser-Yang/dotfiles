local flash_indirect = {
    ['f'] = '<f33>',
    ['t'] = '<f34>',
    ['F'] = '<f35>',
    ['T'] = '<f36>',
}
vim.g.flash_keys = {
    '<f33>',
    '<f34>',
    '<f35>',
    '<f36>',
}
local comma_semicolon = require('comma_semicolon')
local prev_flash_find, next_flash_find =
    comma_semicolon.make(flash_indirect['F'], flash_indirect['f'])
local prev_flash_till, next_flash_till =
    comma_semicolon.make(flash_indirect['T'], flash_indirect['t'])
return {
    'Kaiser-Yang/flash.nvim',
    branch = 'develop',
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
                multi_line = false,
                char_actions = function()
                    return {
                        [';'] = 'next',
                        [','] = 'prev',
                    }
                end,
                label = {
                    exclude = 'hjkliardcg',
                },
                jump = {
                    do_first_jump = true,
                    autojump = true,
                },
                keys = flash_indirect,
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
        { 'F', prev_flash_find, mode = { 'n', 'x' }, desc = 'Flash backwards find' },
        { 'f', next_flash_find, mode = { 'n', 'x' }, desc = 'Flash find' },
        { 'T', prev_flash_till, mode = { 'n', 'x' }, desc = 'Flash backwards till' },
        { 't', next_flash_till, mode = { 'n', 'x' }, desc = 'Flash till' },
        { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
        {
            'R',
            mode = { 'o', 'x' },
            function() require('flash').treesitter_search() end,
            desc = 'Treesitter Search',
        },
        {
            'gn',
            mode = { 'n', 'x', 'o' },
            function() require('flash').treesitter() end,
            desc = 'Flash Treesitter',
        },
        {
            '<c-s>',
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
                local first_visible_line = vim.fn.line('w0')
                local last_visible_line = vim.fn.line('w$')
                flash.jump({
                    search = { mode = 'search' },
                    label = {
                        after = false,
                        before = { 0, 0 },
                        uppercase = false,
                        format = format,
                    },
                    pattern = [[\%<]]
                        .. last_visible_line + 1
                        .. 'l'
                        .. [[\%>]]
                        .. first_visible_line - 1
                        .. 'l'
                        .. [[\<]],
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
