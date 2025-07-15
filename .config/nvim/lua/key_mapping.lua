local utils = require('utils')
local comma_semicolon = require('comma_semicolon')
local map_set_all = utils.map_set_all
local map_del = utils.map_del
map_del({ 'x', 'n' }, 'gc')
map_del({ 'n' }, '<c-w>d')
map_del({ 'n' }, '<c-w><c-d>')
local prev_word, next_word = comma_semicolon.make('b', 'w')
local prev_big_word, next_big_word = comma_semicolon.make('B', 'W')
local prev_end_word, next_end_word = comma_semicolon.make('ge', 'e')
local prev_big_end_word, next_big_end_word = comma_semicolon.make('gE', 'E')
local prev_find, next_find = comma_semicolon.make('F', 'f')
local prev_till, next_till = comma_semicolon.make('T', 't')
local prev_search, next_search = comma_semicolon.make('N', 'n')
local prev_misspell, next_misspell = comma_semicolon.make('[s', ']s')
map_set_all({
    -- Copy, cut, paste, and select all
    { { 'n' }, 'Y', 'y$', { desc = 'Yank till eol' } },
    { { 'n' }, '<m-c>Y', '"+y$', { desc = 'Copy till eol to + reg' } },
    { { 'n' }, '<leader>Y', '"+y$', { desc = 'Yank till eol to + reg' } },
    { { 'n', 'x' }, '<m-c>', '"+y', { desc = 'Copy to + reg' } },
    { { 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to + reg' } },
    {
        'n',
        'yaf',
        function()
            vim.fn.setreg('+', vim.api.nvim_buf_get_lines(0, 0, -1, false), 'l')
            local line_count = vim.api.nvim_buf_line_count(0)
            vim.notify(
                string.format('Yanked %d lines to + register', line_count),
                nil,
                { title = 'Yank' }
            )
        end,
        { desc = 'Yank around file to + reg' },
    },
    { { 'n', 'x' }, '<m-x>', '"+d', { desc = 'Cut to + reg' } },
    {
        { 'n', 'x', 'i' },
        '<c-rightmouse>',
        function()
            local res
            if vim.fn.mode() == 'i' then res = '<c-g>u' end
            local plus_reg_content = vim.fn.getreg('+'):gsub('\r', '')
            if not utils.should_enable_paste_image() then
                vim.fn.setreg('+', plus_reg_content, vim.fn.getregtype('+'))
                if vim.fn.mode() == 'i' then
                    vim.cmd('set paste')
                    res = '<c-r>+'
                    vim.schedule(function() vim.cmd('set nopaste') end)
                else
                    res = '"+p'
                end
            else
                local current_line = vim.api.nvim_get_current_line()
                if not current_line or #current_line == 0 or current_line:find('^%s*$') ~= nil then
                    vim.schedule(function()
                        vim.cmd('normal! dd')
                        require('img-clip').paste_image({ insert_template_after_cursor = false })
                    end)
                    res = ''
                else
                    res = '<cmd>PasteImage<cr>'
                end
            end
            return res
        end,
        {
            desc = 'Paste from + reg',
            expr = true,
        },
    },
    { { 'n', 'x', 'i' }, '<m-v>', '<c-rightmouse>', { desc = 'Paste from + reg', remap = true } },
    {
        { 'n', 'x' },
        '<leader>p',
        function()
            local plus_reg_content = vim.fn.getreg('+'):gsub('\r', '')
            if not utils.should_enable_paste_image() then
                vim.fn.setreg('+', plus_reg_content, vim.fn.getregtype('+'))
                return '"+p'
            else
                return '<cmd>PasteImage<cr>'
            end
        end,
        { desc = 'Paste from clipboard', expr = true },
    },
    {
        { 'n', 'x' },
        '<leader>P',
        function()
            local plus_reg_content = vim.fn.getreg('+'):gsub('\r', '')
            if not utils.should_enable_paste_image() then
                vim.fn.setreg('+', plus_reg_content, vim.fn.getregtype('+'))
                utils.feedkeys('"+P', 'n')
            else
                require('img-clip').paste_image({ insert_template_after_cursor = false })
            end
        end,
        { desc = 'Paste from clipboard' },
    },
    {
        { 'n', 'x', 'i' },
        '<m-a>',
        function()
            vim.g.snacks_animate_scroll = false
            vim.schedule(function() vim.g.snacks_animate_scroll = true end)
            if vim.fn.mode() == 'n' then
                return 'gg0vG$'
            else
                return '<esc>gg0vG$'
            end
        end,
        { desc = 'Select all', expr = true },
    },

    -- Quick operations
    -- {
    --     'i',
    --     '<c-k>',
    --     function()
    --         local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
    --         vim.api.nvim_set_current_line(vim.api.nvim_get_current_line():sub(1, cursor_col))
    --     end,
    --     { desc = 'Delete to end of line' },
    -- },
    -- { 'i', '<m-d>', '<c-g>u<cmd>normal de<cr>', { desc = 'Delete word forwards' } },
    {
        'i',
        '<c-u>',
        function()
            local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
            local line = vim.api.nvim_get_current_line()
            vim.api.nvim_win_set_cursor(
                0,
                { vim.api.nvim_win_get_cursor(0)[1], #line:match('^%s*') }
            )
            vim.api.nvim_set_current_line(line:match('^%s*') .. line:sub(cursor_col + 1))
        end,
        { desc = 'Delete to start of line' },
    },
    {
        'i',
        '<c-w>',
        function()
            local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
            local line_len = #vim.api.nvim_get_current_line()
            local res = '<c-g>u<c-o>'
            if cursor_col == line_len then
                res = res .. 'vlbc'
            else
                res = res .. 'lcb'
            end
            return res
        end,
        { desc = 'Delete word backwards', expr = true, remap = true },
    },
    {
        { 'x', 'i', 'c' },
        '<c-a>',
        function()
            if vim.fn.mode() == 'c' then return '<home>' end
            if vim.fn.mode() ~= 'n' then return '<c-o>^' end
            return '^'
        end,
        { desc = 'Move cursor to start of line', expr = true },
    },
    {
        { 'x', 'i', 'c' },
        '<c-e>',
        '<end>',
        { desc = 'Move cursor to end of line' },
    },

    -- Windows related
    {
        'n',
        '<leader>l',
        '<cmd>set splitright<cr><cmd>vsplit<cr><cmd>set nosplitright<cr>',
        { desc = 'Split vertically' },
    },
    {
        'n',
        '<leader>j',
        '<cmd>set splitbelow<cr><cmd>split<cr><cmd>set nosplitbelow<cr>',
        { desc = 'Split below' },
    },
    { 'n', '<leader>h', '<cmd>vsplit<cr>', { desc = 'Split  vertically' } },
    { 'n', '<leader>k', '<cmd>split<cr>', { desc = 'Split above' } },
    { 'n', '=', '<cmd>wincmd =<cr>', { desc = 'Equalize windows' } },
    { 'n', '<c-h>', '<c-w>h', { desc = 'Cursor left' } },
    { 'n', '<c-j>', '<c-w>j', { desc = 'Cursor down' } },
    { 'n', '<c-k>', '<c-w>k', { desc = 'Cursor up' } },
    { 'n', '<c-l>', '<c-w>l', { desc = 'Cursor right' } },
    { 'n', '<leader>T', '<cmd>tabedit %<cr>', { desc = 'Move current window to a new tabpage' } },

    -- Tabsize related
    {
        'n',
        '<leader>t2',
        function()
            vim.bo.tabstop = 2
            vim.bo.shiftwidth = 2
        end,
        { desc = 'Set tab with 2 spaces' },
    },
    {
        'n',
        '<leader>t4',
        function()
            vim.bo.tabstop = 4
            vim.bo.shiftwidth = 4
        end,
        { desc = 'Set tab with 4 spaces' },
    },
    {
        'n',
        '<leader>t8',
        function()
            vim.bo.tabstop = 8
            vim.bo.shiftwidth = 8
        end,
        { desc = 'Set tab with 8 spaces' },
    },
    {
        'n',
        '<leader>tt',
        function()
            if vim.bo.expandtab then
                vim.bo.expandtab = false
                vim.notify('Expandtab disabled', nil, { title = 'Settings' })
            else
                vim.bo.expandtab = true
                vim.notify('Expandtab enabled', nil, { title = 'Settings' })
            end
        end,
        { desc = 'Toggle expandtab' },
    },

    -- Motion
    { { 'n', 'o', 'x' }, 'b', prev_word, { desc = 'Previous word', expr = true } },
    { { 'n', 'o', 'x' }, 'w', next_word, { desc = 'Next word', expr = true } },
    { { 'n', 'o', 'x' }, 'B', prev_big_word, { desc = 'Previous big word', expr = true } },
    { { 'n', 'o', 'x' }, 'W', next_big_word, { desc = 'Next big word', expr = true } },
    { { 'n', 'o', 'x' }, 'ge', prev_end_word, { desc = 'Previous end word', expr = true } },
    { { 'n', 'o', 'x' }, 'e', next_end_word, { desc = 'Next end word', expr = true } },
    { { 'n', 'o', 'x' }, 'gE', prev_big_end_word, { desc = 'Previous big end word', expr = true } },
    { { 'n', 'o', 'x' }, 'E', next_big_end_word, { desc = 'Next big end word', expr = true } },
    { { 'n', 'o', 'x' }, 'F', prev_find, { desc = 'Previous find character', expr = true } },
    { { 'n', 'o', 'x' }, 'f', next_find, { desc = 'Next find character', expr = true } },
    { { 'n', 'o', 'x' }, 'T', prev_till, { desc = 'Previous till character', expr = true } },
    { { 'n', 'o', 'x' }, 't', next_till, { desc = 'Next till character', expr = true } },
    { { 'n', 'o', 'x' }, 'N', prev_search, { desc = 'Previous search pattern', expr = true } },
    { { 'n', 'o', 'x' }, 'n', next_search, { desc = 'Next search pattern', expr = true } },
    { { 'n', 'o', 'x' }, '[s', prev_misspell, { desc = 'Previous misspelled word', expr = true } },
    { { 'n', 'o', 'x' }, ']s', next_misspell, { desc = 'Next misspelled word', expr = true } },

    -- Others
    { { 'i' }, '<c-n>', '<nop>' },
    { { 'i' }, '<c-p>', '<nop>' },
    {
        'n',
        '<leader>sc',
        function()
            if vim.o.spell then
                vim.notify('Spell check disabled', nil, { title = 'Spell Check' })
            else
                vim.notify('Spell check enabled', nil, { title = 'Spell Check' })
            end
            vim.cmd('set spell!')
        end,
        { desc = 'Toggle spell check' },
    },
    {
        'n',
        '<leader>I',
        function()
            if vim.lsp.inlay_hint.is_enabled() then
                vim.notify('Inlay hints disabled', nil, { title = 'LSP' })
            else
                vim.notify('Inlay hints enabled', nil, { title = 'LSP' })
            end
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end,
        { desc = 'Toggle inlay hints' },
    },
})
