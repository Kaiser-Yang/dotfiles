local map_set = require('utils').map_set
local map_del = require('utils').map_del

map_del({ 'x', 'n' }, 'gc')
map_del({ 'n' }, '<c-w>d')
map_del({ 'n' }, '<c-w><c-d>')
map_set({ 'i' }, '<c-p>', '<nop>')

map_set({ 'n' }, 'Y', 'y$')
map_set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to + reg' })
map_set({ 'n', 'x' }, '<leader>p', function()
    vim.fn.setreg('+', vim.fn.getreg('+'):gsub('\r', ''), vim.fn.getregtype('+'))
    return '"+p'
end, { desc = 'Paste from + reg', expr = true })
map_set({ 'n', 'x' }, '<leader>P', function()
    vim.fn.setreg('+', vim.fn.getreg('+'):gsub('\r', ''), vim.fn.getregtype('+'))
    return '"+P'
end, { desc = 'Paste before from + reg', expr = true })
map_set({ 'n' }, '<leader>ay', function()
    local cur = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_command('normal! ggVGy')
    vim.api.nvim_win_set_cursor(0, cur)
    vim.defer_fn(function() vim.fn.setreg('+', vim.fn.getreg('"')) end, 0)
end, { desc = 'Yank all to + reg' })
map_set({ 'n' }, '<leader>Y', '"+y$', { desc = 'Yank till eol to + reg' })
map_set({ 'n' }, '<leader>sc', function()
    if vim.o.spell then
        vim.notify('Spell check disabled', nil, { title = 'Spell Check' })
    else
        vim.notify('Spell check enabled', nil, { title = 'Spell Check' })
    end
    vim.cmd('set spell!')
end, { desc = 'Toggle spell check' })
map_set({ 'n' }, '<leader><cr>', '<cmd>nohlsearch<cr>', { desc = 'No hlsearch' })
map_set(
    { 'n' },
    '<leader>h',
    '<cmd>set nosplitright<cr><cmd>vsplit<cr><cmd>set splitright<cr>',
    { desc = 'Split left' }
)
map_set({ 'n' }, '<leader>l', '<cmd>set splitright<cr><cmd>vsplit<cr>', { desc = 'Split right' })
map_set({ 'n' }, '<leader>j', '<cmd>set splitbelow<cr><cmd>split<cr>', { desc = 'Split below' })
map_set(
    { 'n' },
    '<leader>k',
    '<cmd>set nosplitbelow<cr><cmd>split<cr><cmd>set splitbelow<cr>',
    { desc = 'Split above' }
)
map_set({ 'i', 'x', 'v', 'n' }, '<c-n>', '<esc>')
map_set({ 'c' }, '<c-n>', '<c-c>')
map_set({ 'n' }, '<leader>I', function()
    if vim.lsp.inlay_hint.is_enabled() then
        vim.notify('Inlay hints disabled', nil, { title = 'LSP' })
    else
        vim.notify('Inlay hints enabled', nil, { title = 'LSP' })
    end
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle inlay hints' })

-- Delete backwards till the non-blank character of the line
map_set({ 'i' }, '<c-u>', function()
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], #line:match('^%s*') })
    vim.api.nvim_set_current_line(line:match('^%s*') .. line:sub(cursor_col + 1))
end)
-- Delete forwards till $
map_set({ 'i' }, '<c-k>', function()
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
    vim.api.nvim_set_current_line(vim.api.nvim_get_current_line():sub(1, cursor_col))
end)
map_set({ 'i' }, '<m-d>', '<cmd>normal! de<cr>')
map_set({ 'i' }, '<c-a>', function()
    local line = vim.api.nvim_get_current_line()
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], #line:match('^%s*') })
end)
map_set({ 'i' }, '<c-e>', function()
    local line = vim.api.nvim_get_current_line()
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], #line })
end)
map_set({ 'n' }, '=', '<cmd>wincmd =<cr>', { desc = 'Equalize windows' })
map_set({ 'n' }, '<c-h>', '<c-w>h', { desc = 'Cursor left' })
map_set({ 'n' }, '<c-j>', '<c-w>j', { desc = 'Cursor down' })
map_set({ 'n' }, '<c-k>', '<c-w>k', { desc = 'Cursor up' })
map_set({ 'n' }, '<c-l>', '<c-w>l', { desc = 'Cursor right' })
map_set({ 'n' }, '<leader>T', '<c-w>T', { desc = 'Move current window to a new tabpage' })
map_set({ 'n' }, '<leader>t2', function()
    vim.o.tabstop = 2
    vim.o.shiftwidth = 2
    vim.o.softtabstop = 2
end, { desc = 'Set tab with 2 spaces' })
map_set({ 'n' }, '<leader>t4', function()
    vim.o.tabstop = 4
    vim.o.shiftwidth = 4
    vim.o.softtabstop = 4
end, { desc = 'Set tab with 4 spaces' })
map_set(
    { 'n' },
    '<leader>tt',
    function()
        if vim.o.expandtab then
            vim.o.expandtab = false
            vim.notify('Expandtab disabled', nil, { title = 'Settings' })
        else
            vim.o.expandtab = true
            vim.notify('Expandtab enabled', nil, { title = 'Settings' })
        end
    end,
    { desc = 'Toggle expandtab' }
)
