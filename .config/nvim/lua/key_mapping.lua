local utils = require('utils')
local map_set = utils.map_set
local map_del = utils.map_del
map_del({ 'x', 'n' }, 'gc')
map_del({ 'n' }, '<c-w>d')
map_del({ 'n' }, '<c-w><c-d>')
local key_mappings = {
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
            local plus_reg_content = vim.fn.getreg('+'):gsub('\r', '')
            if not utils.should_enable_paste_image() then
                vim.fn.setreg('+', plus_reg_content, vim.fn.getregtype('+'))
                if vim.fn.mode() == 'i' then
                    res = '<c-r>+'
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

    -- TODO: make those mappings work in cmd mode
    -- Quick operations
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
        '<c-k>',
        function()
            local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
            vim.api.nvim_set_current_line(vim.api.nvim_get_current_line():sub(1, cursor_col))
        end,
        { desc = 'Delete to end of line' },
    },
    { 'i', '<m-d>', '<c-g>u<cmd>normal de<cr>', { desc = 'Delete word forwards' } },
    { 'i', '<c-w>', '<c-g>u<cmd>normal db<cr>', { desc = 'Delete word backwards' } },
    {
        { 'n', 'x', 'i' },
        '<c-a>',
        function()
            local line = vim.api.nvim_get_current_line()
            vim.api.nvim_win_set_cursor(
                0,
                { vim.api.nvim_win_get_cursor(0)[1], #line:match('^%s*') }
            )
        end,
        { desc = 'Move cursor to start of line' },
    },
    {
        { 'n', 'x', 'i' },
        '<c-e>',
        function()
            local line = vim.api.nvim_get_current_line()
            vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], #line })
        end,
        { desc = 'Move cursor to end of line' },
    },

    -- Windows related
    {
        { 'n' },
        '<leader>h',
        '<cmd>set nosplitright<cr><cmd>vsplit<cr><cmd>set splitright<cr>',
        { desc = 'Split  vertically' },
    },
    { { 'n' }, '<leader>l', '<leader>h', { desc = 'Split vertically', remap = true } },
    { { 'n' }, '<leader>j', '<cmd>split<cr>', { desc = 'Split below' } },
    { { 'n' }, '<leader>k', '<leader>j', { desc = 'Split above', remap = true } },
    { { 'n' }, '=', '<cmd>wincmd =<cr>', { desc = 'Equalize windows' } },
    { { 'n' }, '<c-h>', '<c-w>h', { desc = 'Cursor left' } },
    { { 'n' }, '<c-j>', '<c-w>j', { desc = 'Cursor down' } },
    { { 'n' }, '<c-k>', '<c-w>k', { desc = 'Cursor up' } },
    { { 'n' }, '<c-l>', '<c-w>l', { desc = 'Cursor right' } },
    {
        'n',
        '<leader>T',
        '<cmd>tabedit %<cr>',
        { desc = 'Move current window to a new tabpage' },
    },

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
}
for _, key in ipairs(key_mappings) do
    map_set(unpack(key))
end
