local utils = require('utils')
-- INFO:
-- only load 10 buffers by default
-- We use LFU (Least Frequently Used) algorithm to remove the least used buffers
vim.g.buffer_limit = 10
-- INFO: Those variables do not support wildcards
vim.g.markdown_support_filetype = { 'markdown', 'gitcommit', 'text', 'Avante' }
vim.g.root_markers =
    { '.vscode', '.nvim', '.git', '.root', 'pom.xml', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
vim.g.frontend_filetype = { 'typescript', 'javascript', 'vue', 'html', 'css' }

vim.g.big_file_limit = 5 * 1024 * 1024 -- 5 MB
vim.g.big_file_limit_per_line = 1 * 1024 -- 1 KB
vim.g.big_dir_file_name = '.big_dir_files' -- The file name to store big dir files
vim.g.only_vscode_launch = false -- Only use the .vscode/launch.json for dap

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
vim.o.jumpoptions = 'clean'
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
        if not utils.cursor_in_match() then vim.schedule(function() vim.cmd('nohlsearch') end) end
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    group = 'UserDIY',
    pattern = 'gitcommit',
    callback = function() vim.wo.colorcolumn = '50,72' end,
})
vim.api.nvim_create_autocmd('VimLeavePre', {
    group = 'UserDIY',
    callback = function()
        -- get all the buffers, and delete all non-modifiable buffers
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if not vim.bo[buf].modifiable then vim.api.nvim_buf_delete(buf, { force = true }) end
        end
    end,
})
local refresh_project_config = function(show_info)
    local project_config_dir = vim.fn.getcwd() .. '/.nvim'
    -- source all the lua files in the project config directory
    local files = vim.fn.globpath(project_config_dir, '*.lua', false, true)
    for _, file in ipairs(files) do
        if vim.fn.filereadable(file) == 1 then
            local ok, err = pcall(function() vim.cmd('source ' .. file) end)
            if not ok then
                vim.notify('Error sourcing file: ' .. file .. '\n' .. err, vim.log.levels.ERROR)
                return false
            elseif show_info then
                vim.notify('Sourced file: ' .. file, vim.log.levels.INFO)
            end
        else
            vim.notify('File not readable: ' .. file, vim.log.levels.WARN)
            return false
        end
        return true
    end
end
vim.api.nvim_create_autocmd('BufLeave', {
    group = 'UserDIY',
    pattern = '*',
    callback = function()
        if
            not vim.bo.filetype:match('snacks')
            and not vim.bo.filetype:match('neo%-tree')
            and vim.fn.mode() == 'i'
        then
            vim.cmd('stopinsert')
        end
    end,
})
vim.api.nvim_create_autocmd('VimEnter', {
    group = 'UserDIY',
    callback = function() refresh_project_config(false) end,
})
vim.api.nvim_create_user_command(
    'RefreshProjectConfig',
    function() refresh_project_config(true) end,
    {}
)
vim.api.nvim_create_user_command('GenBigDirFiles', function()
    if vim.fn.executable('rg') == 0 then
        vim.notify('rg is not executable, please install it first', vim.log.levels.ERROR)
        return
    end
    local cmd = 'rg'
    local args = {
        '--hidden',
        '--files',
        '--no-messages',
        '--color',
        'never',
        '--no-ignore',
        '-g',
        '!.git',
        '-g',
        '!' .. vim.g.big_dir_file_name,
    }
    local output_path = utils.get_big_dir_output_path()
    vim.system({ cmd, unpack(args) }, { text = true }, function(result)
        if result.code ~= 0 then
            vim.notify('Failed to generate big dir files: ' .. result.stderr, vim.log.levels.ERROR)
            return
        end
        local f = io.open(output_path, 'w')
        if not f then
            vim.notify('Failed to open file for writing: ' .. output_path, vim.log.levels.ERROR)
            return
        end
        f:write(result.stdout)
        f:close()
        vim.notify('Big dir files generated successfully: ' .. output_path, vim.log.levels.INFO)
    end)
end, {})
vim.filetype.add({
    pattern = {
        ['.*.bazelrc'] = 'bazelrc',
    },
})
vim.api.nvim_create_autocmd('BufEnter', {
    callback = function()
        if not utils.is_visible_buffer() then return end
        _G.buffer_cache = _G.buffer_cache or require('lfu').new(vim.g.buffer_limit)
        local deleted_buf, _ = _G.buffer_cache:set(vim.api.nvim_get_current_buf(), true)
        if deleted_buf then utils.bufdelete(deleted_buf) end
    end,
})
