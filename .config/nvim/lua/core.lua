-- INFO: Those variables do not support wildcards
vim.g.markdown_support_filetype = { 'markdown', 'gitcommit', 'text', 'Avante' }
vim.g.root_markers = { '.git', '.root', 'pom.xml', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
vim.g.frontend_filetype = { 'typescript', 'javascript', 'vue', 'html', 'css' }

vim.g.big_file_limit = 0.5 * 1024 * 1024 -- 0.5 MB

-- When input method is enabled, disable the following patterns
vim.g.disable_rime_ls_pattern = {
    -- disable in ``
    '`([%w%s%p]*)`',
    -- disable in ''
    "'([%w%s%p]*)'",
    -- disable in ""
    '"([%w%s%p]*)"',
    -- disable after ```
    '```[%w%s%p]*',
    -- disable in $$
    '%$[%w%s%p]*%$',
}

vim.g.mapleader = ' '

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.cmdheight = 0
vim.o.signcolumn = 'yes'
vim.o.jumpoptions = 'stack,clean'
vim.o.termguicolors = true
vim.o.spelllang = 'en_us,en'
vim.o.timeoutlen = 300
vim.o.ttimeoutlen = 0
vim.o.mouse = 'a'
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 5
vim.o.colorcolumn = '100'
vim.o.cursorline = true
vim.o.list = true
vim.o.listchars = 'tab:»-,trail:·,lead:·'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true
-- Use spaces to substitute tabs
vim.o.expandtab = true
-- One tab is shown as 4 spaces
vim.o.tabstop = 4
-- >> and << will shift lines by 4
vim.o.shiftwidth = 4
-- Every <tab> will go right by 4 spaces, every <bs> will go left by 4 spaces
vim.o.showbreak = '↪'
vim.o.encoding = 'utf-8'
vim.o.foldlevel = 99
vim.o.sessionoptions = 'buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions'

vim.api.nvim_create_augroup('UserDIY', {})
-- When leaving normal mode, disable hlsearch
vim.api.nvim_create_autocmd('ModeChanged', {
    group = 'UserDIY',
    pattern = 'n:[^n]',
    callback = function()
        vim.schedule(function() vim.cmd('nohlsearch') end)
    end,
})
-- When moving cursor out of a match, disable hlsearch
vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
    group = 'UserDIY',
    callback = function()
        local mode = vim.fn.mode()
        if mode ~= 'n' then return end -- Only handle normal mode
        local pattern = vim.fn.getreg('/') -- Get last search pattern
        if pattern == '' then return end -- Skip if no pattern
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local match_pos = vim.fn.matchbufline(
            vim.api.nvim_get_current_buf(),
            pattern,
            cursor_pos[1],
            cursor_pos[1]
        )
        local cursor_in_match = false
        for _, match in pairs(match_pos) do
            if match.byteidx <= cursor_pos[2] and match.byteidx + #match.text > cursor_pos[2] then
                cursor_in_match = true
                break
            end
        end
        if not cursor_in_match then
            vim.schedule(function() vim.cmd('nohlsearch') end)
        else
            vim.schedule(function() vim.cmd('set hlsearch') end)
        end
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    group = 'UserDIY',
    pattern = 'gitcommit',
    callback = function() vim.wo.colorcolumn = '50,72' end,
})
vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function()
        -- get all the buffers, and delete all non-modifiable buffers
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if not vim.bo[buf].modifiable then vim.api.nvim_buf_delete(buf, { force = true }) end
        end
    end,
})
