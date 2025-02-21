-- INFO: Those variables do not support wildcards
vim.g.markdown_support_filetype = { 'markdown', 'gitcommit', 'text', 'Avante' }
vim.g.root_markers = { '.git', '.root', 'pom.xml' }
vim.g.frontend_filetype = { 'typescript', 'javascript', 'vue', 'html', 'css' }

vim.g.big_file_limit = 1 * 1024 * 1024 -- 1 MB

-- When input method is enabled, disable the following patterns
vim.g.disable_rime_ls_pattern = {
    -- disable in ``
    '`([%w%s%p]*)`',
    -- disable in ''
    '\'([%w%s%p]*)\'',
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

vim.o.signcolumn = 'yes'
vim.o.jumpoptions = 'stack'
vim.o.termguicolors = true
vim.o.spelllang = 'en_us,en'
vim.o.timeoutlen = 300
vim.o.ttimeoutlen = 0
vim.o.mouse = 'a'
vim.o.mousemoveevent = true
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
-- user spaces to substitute tabs
vim.o.expandtab = true
-- one tab is shown as 4 spaces
vim.o.tabstop = 4
-- >> and << will shift lines by 4
vim.o.shiftwidth = 4
-- every <tab> will go right by 4 spaces, every <bs> will go left by 4 spaces
vim.o.softtabstop = 4
vim.o.showbreak = '↪'
vim.o.encoding = 'utf-8'
vim.o.switchbuf = 'useopen'
vim.o.foldenable = false
vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.diagnostic.config({
    update_in_insert = true,
    virtual_text = false,
    signs = true,
    underline = true,
})
vim.api.nvim_create_augroup('UserDIY', {})
-- When leaving normal mode, disable hlsearch
vim.api.nvim_create_autocmd('ModeChanged', {
    group = 'UserDIY',
    pattern = 'n:[^n]',
    callback = function()
        vim.schedule(function() vim.cmd('nohlsearch') end)
    end
})
vim.api.nvim_create_autocmd('FileType', {
    group = 'UserDIY',
    pattern = 'gitcommit',
    callback = function()
        vim.wo.colorcolumn = '50,72'
    end
})
vim.api.nvim_create_autocmd('SwapExists', {
    pattern = '*',
    callback = function()
        vim.v.swapchoice = 'e'
    end
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = vim.g.frontend_filetype,
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
    end
})
