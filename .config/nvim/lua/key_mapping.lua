local map_set = require('utils').map_set
local map_del = require('utils').map_del

map_del({ 'x', 'n' }, 'gc')
map_del({ 'n' }, '<c-w>d')
map_del({ 'n' }, '<c-w><c-d>')

map_set({ 'n' }, 'Y', 'y$')
map_set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to + reg' })
map_set({ 'n', 'x' }, '<leader>p', '"+p', { desc = 'Paste from + reg' })
map_set({ 'n', 'x' }, '<leader>P', '"+P', { desc = 'Paste before from + reg' })
map_set({ 'n' }, '<leader>ay', function()
    local cur = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_command('normal! ggVGy')
    vim.api.nvim_win_set_cursor(0, cur)
    vim.defer_fn(function() vim.fn.setreg('+', vim.fn.getreg('"')) end, 0)
end, { desc = 'Yank all to + reg' })
map_set({ 'n' }, '<leader>Y', '"+y$', { desc = 'Yank till eol to + reg' })
map_set({ 'n' }, '<leader>sc', '<cmd>set spell!<cr>', { desc = 'Toggle spell check' })
map_set({ 'n' }, '<leader><cr>', '<cmd>nohlsearch<cr>', { desc = 'No hlsearch' })
map_set({ 'n' }, '<leader>h', '<cmd>set nosplitright<cr><cmd>vsplit<cr><cmd>set splitright<cr>',
    { desc = 'Split right' })
map_set({ 'n' }, '<leader>l', '<cmd>set splitright<cr><cmd>vsplit<cr>',
    { desc = 'Split left' })
map_set({ 'i', 'c', 'x', 'v', 'n' }, '<c-n>', '<esc>', { remap = true })
map_set({ 'n' }, '<leader>i', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle inlay hints' })

map_set({ 'i' }, '<c-u>', function()
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], #line:match('^%s*') })
    vim.api.nvim_set_current_line(line:match('^%s*') .. line:sub(cursor_col + 1))
end)
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
