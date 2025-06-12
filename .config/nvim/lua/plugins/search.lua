local flash_keys = {
    ['f'] = '<f40>',
    ['t'] = '<f41>',
    ['F'] = '<f42>',
    ['T'] = '<f43>',
}
local utils = require('utils')
local map_set = utils.map_set
return {
    'Kaiser-Yang/flash.nvim',
    event = 'VeryLazy',
    branch = 'develop',
    depedencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    ---@type Flash.Config
    opts = {
        actions = {
            [''] = function() return false end,
        },
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
                    exclude = '',
                },
                jump = {
                    do_first_jump = false,
                    autojump = true,
                },
                keys = flash_keys,
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
            'gn',
            mode = { 'n', 'x', 'o' },
            function() require('flash').treesitter() end,
            desc = 'Flash Treesitter',
        },
        -- {
        -- For most terminals, this is the same as <c-/>
        -- '<c-_>',
        -- mode = { 'n', 'x', 'o' },
        -- function()
        --     local word = vim.fn.histget('/', -1)
        --     require('flash').jump({
        --         search = { mode = 'search' },
        --         pattern = word,
        --     })
        -- end,
        -- desc = 'Flash Search Last Searched Word',
        -- },
        {
            '*',
            mode = { 'n', 'x', 'o' },
            function()
                local word = vim.fn.expand('<cword>')
                require('flash').jump({
                    search = {
                        mode = 'search',
                        forward = true,
                        wrap = false,
                        multi_window = false,
                    },
                    jump = {
                        history = true,
                        register = true,
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
                        mode = 'search',
                        forward = false,
                        wrap = false,
                        multi_window = false,
                    },
                    jump = {
                        history = true,
                        register = true,
                    },
                    pattern = word,
                })
            end,
            desc = 'Flash Search Current Word Backward',
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
    config = function(_, opts)
        require('flash').setup(opts)
        local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
        for key, _ in pairs(flash_keys) do
            map_set({ 'n', 'x' }, key, function()
                ts_repeat_move['builtin_' .. key .. '_expr']()
                vim.schedule(function()
                    local ok, char = pcall(vim.fn.getcharstr)
                    if ok and #char == 1 then
                        local byte = string.byte(char)
                        if byte >= 32 and byte <= 126 then
                            -- Only record printable character
                            vim.g.last_motion = key
                            vim.g.last_motion_char = char
                        end
                    end
                    char = char or ''
                    utils.feedkeys(key .. char, 'n')
                end)
            end)
        end
        map_set({ 'n', 'x', 'o' }, ';', function()
            local last_move = ts_repeat_move.last_move
            if
                last_move
                and vim.tbl_contains({ 'f', 't', 'F', 'T' }, last_move.func)
                and vim.g.last_motion
                and vim.g.last_motion_char
            then
                utils.feedkeys(flash_keys[vim.g.last_motion] .. vim.g.last_motion_char, 'm')
                return
            end
            ts_repeat_move.repeat_last_move()
        end)
        map_set({ 'n', 'x', 'o' }, ',', function()
            local last_move = ts_repeat_move.last_move
            if
                last_move
                and vim.tbl_contains({ 'f', 't', 'F', 'T' }, last_move.func)
                and vim.g.last_motion
                and vim.g.last_motion_char
            then
                local reversed_key = vim.g.last_motion:gsub(
                    '%a',
                    function(c) return c == c:lower() and c:upper() or c:lower() end
                )
                utils.feedkeys(flash_keys[reversed_key] .. vim.g.last_motion_char, 'm')
                return
            end
            ts_repeat_move.repeat_last_move_opposite()
        end)
    end,
}
