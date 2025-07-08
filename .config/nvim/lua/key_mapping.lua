local utils = require('utils')
local map_set = utils.map_set
local map_del = utils.map_del

map_del({ 'x', 'n' }, 'gc')
map_del({ 'n' }, '<c-w>d')
map_del({ 'n' }, '<c-w><c-d>')
map_set({ 'i' }, '<c-p>', '<nop>')
map_set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to + reg' })
map_set({ 'n' }, '<leader>Y', '"+y$', { desc = 'Yank till eol to + reg' })
map_set({ 'n' }, 'Y', 'y$', { desc = 'Yank till eol' })
map_set('x', '<c-insert>', '"+y', { desc = 'Yank to +reg' })
map_set('x', '<c-x>', '"+d', { desc = 'Delete to +reg' })
map_set({ 'x' }, '<c-insert>', '"+y', { desc = 'Copy to +reg' })
map_set({ 'n', 'x' }, '<s-insert>', '"+p', { desc = 'Paste from +reg' })

if vim.fn.has('mac') == 1 then map_set({ 'x' }, '<del>', '"+y', { desc = 'Copy to +reg' }) end

map_set({ 'n', 'i' }, '<c-rightmouse>', function()
    local res
    local plus_reg_content = vim.fn.getreg('+'):gsub('\r', '')
    if not utils.should_enable_paste_image() then
        vim.fn.setreg('+', plus_reg_content, vim.fn.getregtype('+'))
        res = '<cmd>normal! "+p<cr>'
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
end, {
    desc = 'Paste from clipboard or insert image',
    expr = true,
})
map_set({ 'n', 'x' }, '<leader>p', function()
    local plus_reg_content = vim.fn.getreg('+'):gsub('\r', '')
    if not utils.should_enable_paste_image() then
        vim.fn.setreg('+', plus_reg_content, vim.fn.getregtype('+'))
        return '"+p'
    else
        return '<cmd>PasteImage<cr>'
    end
end, { desc = 'Paste from clipboard or insert image', expr = true })
map_set({ 'n', 'x' }, '<leader>P', function()
    local plus_reg_content = vim.fn.getreg('+'):gsub('\r', '')
    if not utils.should_enable_paste_image() then
        vim.fn.setreg('+', plus_reg_content, vim.fn.getregtype('+'))
        utils.feedkeys('"+P', 'n')
    else
        require('img-clip').paste_image({ insert_template_after_cursor = false })
    end
end, { desc = 'Paste from clipboard or insert image' })
map_set('i', '<s-insert>', function()
    local plus_reg_content = vim.fn.getreg('+'):gsub('\r', '')
    if not utils.should_enable_paste_image() then
        vim.fn.setreg('+', plus_reg_content, vim.fn.getregtype('+'))
        return '<c-r>+'
    else
        return '<cmd>PasteImage<cr>'
    end
end, { desc = 'Paste from +reg', expr = true })
map_set({ 'n' }, 'yaf', function()
    vim.fn.setreg('+', vim.api.nvim_buf_get_lines(0, 0, -1, false), 'l')
    local line_count = vim.api.nvim_buf_line_count(0)
    vim.notify(string.format('Yanked %d lines to + register', line_count), nil, { title = 'Yank' })
end, { desc = 'Yank all to + reg' })
map_set({ 'n' }, '<leader>sc', function()
    if vim.o.spell then
        vim.notify('Spell check disabled', nil, { title = 'Spell Check' })
    else
        vim.notify('Spell check enabled', nil, { title = 'Spell Check' })
    end
    vim.cmd('set spell!')
end, { desc = 'Toggle spell check' })
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
map_set({ 'i', 'c' }, '<m-d>', '<c-g>u<cmd>normal de<cr>')
map_set({ 'i', 'c' }, '<c-w>', '<c-g>u<cmd>normal db<cr>', { desc = 'Delete word backwards' })
map_set({ 'i', 'c' }, '<c-a>', function()
    local line = vim.api.nvim_get_current_line()
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], #line:match('^%s*') })
end)
map_set({ 'i', 'c' }, '<c-e>', function()
    local line = vim.api.nvim_get_current_line()
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], #line })
end)
map_set({ 'n' }, '=', '<cmd>wincmd =<cr>', { desc = 'Equalize windows' })
map_set({ 'n' }, '<c-h>', '<c-w>h', { desc = 'Cursor left' })
map_set({ 'n' }, '<c-j>', '<c-w>j', { desc = 'Cursor down' })
map_set({ 'n' }, '<c-k>', '<c-w>k', { desc = 'Cursor up' })
map_set({ 'n' }, '<c-l>', '<c-w>l', { desc = 'Cursor right' })
map_set(
    { 'n' },
    '<leader>T',
    '<cmd>tabedit %<cr>',
    { desc = 'Move current window to a new tabpage' }
)
map_set({ 'n' }, '<leader>t2', function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
end, { desc = 'Set tab with 2 spaces' })
map_set({ 'n' }, '<leader>t4', function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
end, { desc = 'Set tab with 4 spaces' })
map_set({ 'n' }, '<leader>t8', function()
    vim.bo.tabstop = 8
    vim.bo.shiftwidth = 8
end, { desc = 'Set tab with 8 spaces' })
map_set({ 'n' }, '<leader>tt', function()
    if vim.bo.expandtab then
        vim.bo.expandtab = false
        vim.notify('Expandtab disabled', nil, { title = 'Settings' })
    else
        vim.bo.expandtab = true
        vim.notify('Expandtab enabled', nil, { title = 'Settings' })
    end
end, { desc = 'Toggle expandtab' })
