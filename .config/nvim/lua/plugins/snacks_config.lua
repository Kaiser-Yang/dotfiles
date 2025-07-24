-- FIX:
-- Use <c-p> to open file picker,
-- then use <c-f> to switch to grep picker,
-- then <c-p> can not switch back to file picker, unless you press <c-p> twice.
-- When there are more than one window before enterint pickers, and switch to another picker
-- and on confirm may enter the wrong window.
local utils = require('utils')
local map_set = utils.map_set
local file_ignore_patterns = {
    '*.git',
    '*.root',
    '*.o',
    '*.out',
    '*.exe',
    '*.png',
    '*.gif',
    '*.jpg',
    '*.so',
    '*.a',
    '*.dll',
    '*.dylib',
    '*.class',
    '*.jar',
    '*.zip',
    '*.tar.gz',
    '3rdparty',
}
local live_grep_limit = 100
local prev_word_ref, next_word_ref = require('comma_semicolon').make(
    function() Snacks.words.jump(-vim.v.count1, true) end,
    function() Snacks.words.jump(vim.v.count1, true) end
)
local key_state = {
    hlsearch = false,
    diagnostic = false,
    mouse_scroll = false,
}
local function set_key_state(key)
    for k, _ in pairs(key_state) do
        if k ~= key then key_state[k] = false end
    end
    if key then key_state[key] = true end
end
vim.on_key(function(key, typed)
    key = typed or key
    if key == utils.termcodes('<ScrollWheelUp>') or key == utils.termcodes('<ScrollWheelDown>') then
        set_key_state('monse_scroll')
    elseif key == utils.termcodes('n') or key == utils.termcodes('N') then
        set_key_state('hlsearch')
    elseif key == utils.termcodes('[d') or key == utils.termcodes(']d') then
        set_key_state('diagnostic')
    elseif not key:match('^%s*$') then
        vim.schedule(function() vim.cmd('nohlsearch') end)
        set_key_state()
    end
end)
vim.api.nvim_create_autocmd('WinScrolled', {
    group = 'UserDIY',
    callback = function()
        for win, changes in pairs(vim.v.event) do
            local delta = math.abs(changes.topline)
            if win and delta <= 1 or delta >= vim.g.big_file_limit_per_line then
                vim.g.snacks_animate_scroll = false
                vim.schedule(function() vim.g.snacks_animate_scroll = true end)
                return
            end
        end
    end,
})
vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function() Snacks.toggle.treesitter():map('<leader>ts') end,
})
vim.api.nvim_create_autocmd('BufEnter', {
    group = 'UserDIY',
    callback = function()
        if vim.bo.filetype == 'snacks_picker_preview' then vim.b.snacks_animate_scroll = nil end
    end,
})
vim.api.nvim_create_autocmd('BufLeave', {
    group = 'UserDIY',
    callback = function()
        if vim.bo.filetype == 'snacks_picker_preview' then vim.b.snacks_animate_scroll = false end
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = {
        'snacks_picker_list',
        'snacks_picker_input',
        'snacks_picker_preview',
    },
    callback = function()
        if vim.bo.filetype == 'snacks_picker_preview' then vim.b.snacks_animate_scroll = false end
        map_set(
            'i',
            '<c-p>',
            function()
                Snacks.picker.files({
                    cmd = 'rg',
                    hidden = not utils.should_ignore_hidden_files(),
                    exclude = file_ignore_patterns,
                    pattern = vim.api.nvim_get_current_line(),
                    layout = {
                        hidden = { 'preview' },
                    },
                })
            end,
            { buffer = true }
        )
        map_set(
            'i',
            '<c-f>',
            function()
                Snacks.picker.grep({
                    cwd = vim.fn.getcwd(),
                    cmd = 'rg',
                    limit = live_grep_limit,
                    hidden = not utils.should_ignore_hidden_files(),
                    exclude = file_ignore_patterns,
                    search = vim.api.nvim_get_current_line(),
                })
            end,
            { buffer = true }
        )
        map_set({ 'i' }, '<c-y>', Snacks.picker.resume, { buffer = true })
    end,
})
local function enable_scroll_for_filetype_once(filetype)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == filetype then
            vim.b[buf].snacks_animate_scroll = nil
            vim.schedule(function() vim.b[buf].snacks_animate_scroll = false end)
            Snacks.scroll.check(win)
        end
    end
end
return {
    'Kaiser-Yang/snacks.nvim',
    branch = 'develop',
    priority = 1000,
    lazy = false,
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
        bigfile = {
            enabled = false,
        },
        dashboard = {
            enabled = false,
        },
        image = {
            enabled = vim.fn.has('wsl') == 0,
        },
        indent = {
            enabled = true,
            animate = {
                enabled = true,
                duration = {
                    total = 300,
                },
            },
            chunk = {
                enabled = true,
                char = {
                    corner_top = '╭',
                    corner_bottom = '╰',
                },
            },
            filter = function(buf)
                return vim.g.snacks_indent ~= false
                    and vim.b[buf].snacks_indent ~= false
                    and vim.bo[buf].buftype == ''
                    and vim.bo[buf].filetype ~= 'markdown'
            end,
        },
        input = { enabled = false },
        ---@class snacks.picker.Config
        picker = {
            enabled = true,
            previewers = {
                file = {
                    max_size = false,
                    max_line_length = 500, -- max line length
                },
            },
            ---@class snacks.picker.jump.Config
            jump = {
                match = true, -- jump to the first match position.
            },
            win = {
                -- input window
                input = {
                    keys = {
                        ['<up>'] = { 'history_back', mode = { 'i', 'n' } },
                        ['<down>'] = { 'history_back', mode = { 'i', 'n' } },
                        ['<c-w>'] = { '<c-s-w>', mode = { 'i' }, expr = true, desc = 'delete word' },
                        ['<c-j>'] = { 'list_down', mode = { 'n', 'i' } },
                        ['<c-k>'] = { 'list_up', mode = { 'n', 'i' } },
                        ['<c-u>'] = {
                            function(picker)
                                enable_scroll_for_filetype_once('snacks_picker_preview')
                                picker.opts.actions.preview_scroll_up.action()
                            end,
                            mode = { 'i', 'n' },
                        },
                        ['<c-d>'] = {
                            function(picker)
                                enable_scroll_for_filetype_once('snacks_picker_preview')
                                picker.opts.actions.preview_scroll_down.action()
                            end,
                            mode = { 'i', 'n' },
                        },
                        ['<c-c>'] = { 'close', mode = { 'n', 'i' } },
                        ['<f1>'] = { 'toggle_help_input', mode = { 'i', 'n' } },
                        ['<cr>'] = { 'confirm', mode = { 'n', 'i' } },
                        ['<c-s>'] = { 'edit_split', mode = { 'i', 'n' } },
                        ['<c-v>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
                        ['<c-r><c-l>'] = {
                            'insert_line',
                            mode = 'i',
                            desc = 'Insert the line under cursor',
                        },
                        ['<c-r><c-w>'] = {
                            'insert_cword',
                            mode = 'i',
                            desc = 'Insert the word under cursor',
                        },
                        ['<c-r><c-a>'] = {
                            'insert_cWORD',
                            mode = 'i',
                            desc = 'Insert the WORD under cursor',
                        },
                        ['<c-r>%'] = {
                            'insert_filename',
                            mode = 'i',
                            desc = "Insert current buffer's filename",
                        },
                        ['<c-r>#'] = {
                            'insert_alt',
                            mode = 'i',
                            desc = 'Insert alternate filename (the last one you edit)',
                        },
                        ['<c-r><c-f>'] = {
                            'insert_file',
                            mode = 'i',
                            desc = 'Insert filename under cursor',
                        },
                        ['<c-r><c-p>'] = {
                            'insert_file_full',
                            mode = 'i',
                            desc = 'Insert full file path under cursor',
                        },
                        ['<a-g>'] = {
                            'toggle_live',
                            mode = { 'i', 'n' },
                        },
                        ['<a-w>'] = { 'toggle_focus', mode = { 'i', 'n' } },
                        ['<a-m>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
                        ['<a-p>'] = { 'toggle_preview', mode = { 'i', 'n' } },
                        -- Toggle whether or not follow link file
                        ['<a-f>'] = { 'toggle_follow', mode = { 'i', 'n' } },
                        ['<a-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
                        ['<a-d>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
                        ['<m-a>'] = { 'select_all', mode = { 'n', 'i' } },
                        ['<tab>'] = { 'select_and_next', mode = { 'i', 'n' } },
                        ['<s-tab>'] = { 'select_and_prev', mode = { 'i', 'n' } },
                        ['?'] = 'toggle_help_input',
                        ['G'] = 'list_bottom',
                        ['gg'] = 'list_top',
                        ['j'] = 'list_down',
                        ['k'] = 'list_up',
                        ['q'] = 'close',
                        ['<esc>'] = 'cancel',
                        ['<c-a>'] = false,
                        ['<c-f>'] = false,
                        ['<c-p>'] = false,
                        ['<c-up>'] = false,
                        ['<c-down>'] = false,
                        ['<c-w>H'] = false,
                        ['<c-w>J'] = false,
                        ['<c-w>K'] = false,
                        ['<c-w>L'] = false,
                        ['<c-t>'] = false,
                        ['/'] = false,
                        ['<s-cr>'] = false,
                        ['<a-h>'] = false,
                        ['<c-q>'] = { 'qflist', mode = { 'i', 'n' } },
                    },
                },
                -- result list window
                list = {
                    keys = {
                        ['?'] = 'toggle_help_list',
                        ['<f1>'] = 'toggle_help_list',
                        ['G'] = 'list_bottom',
                        ['gg'] = 'list_top',
                        ['j'] = 'list_down',
                        ['k'] = 'list_up',
                        ['q'] = 'close',
                        ['zb'] = 'list_scroll_bottom',
                        ['zt'] = 'list_scroll_top',
                        ['zz'] = 'list_scroll_center',
                        ['i'] = 'focus_input',
                        ['a'] = 'focus_input',
                        ['o'] = 'focus_input',
                        ['I'] = 'focus_input',
                        ['A'] = 'focus_input',
                        ['O'] = 'focus_input',
                        ['<2-LeftMouse>'] = 'confirm',
                        ['<cr>'] = 'confirm',
                        ['<esc>'] = 'cancel',
                        ['<c-d>'] = 'list_scroll_down',
                        ['<c-u>'] = 'list_scroll_up',
                        ['<a-w>'] = 'toggle_focus',
                        ['<c-s>'] = 'edit_split',
                        ['<c-v>'] = 'edit_vsplit',
                        ['<a-m>'] = 'toggle_maximize',
                        ['<a-p>'] = 'toggle_preview',
                        ['<a-f>'] = 'toggle_follow', -- Toggle whether of not follow link file
                        ['<a-i>'] = 'toggle_ignored',
                        ['<a-d>'] = 'toggle_hidden',
                        ['<m-a>'] = 'select_all',
                        ['<tab>'] = 'select_and_next',
                        ['<s-tab>'] = 'select_and_prev',
                        ['<c-a>'] = false,
                        ['<c-t>'] = false,
                        ['<c-j>'] = false,
                        ['<c-k>'] = false,
                        ['<c-f>'] = false,
                        ['<c-b>'] = false,
                        ['<c-p>'] = false,
                        ['<up>'] = false,
                        ['<down>'] = false,
                        ['<c-w>H'] = false,
                        ['<c-w>J'] = false,
                        ['<c-w>K'] = false,
                        ['<c-w>L'] = false,
                        ['/'] = false,
                        ['<s-cr>'] = false,
                        ['<c-q>'] = 'qflist',
                    },
                },
                -- preview window
                preview = {
                    keys = {
                        ['i'] = 'focus_input',
                        ['a'] = 'focus_input',
                        ['o'] = 'focus_input',
                        ['I'] = 'focus_input',
                        ['A'] = 'focus_input',
                        ['O'] = 'focus_input',
                        ['q'] = 'close',
                        ['<esc>'] = 'cancel',
                        ['<a-w>'] = 'cycle_win',
                    },
                },
            },
        },
        scope = { enabled = false, treesitter = { enabled = false } },
        scroll = {
            enabled = true,
            filter = function(buf)
                return vim.g.snacks_scroll ~= false
                    and vim.b[buf].snacks_scroll ~= false
                    and vim.bo[buf].buftype ~= 'terminal'
                    and vim.bo[buf].filetype ~= 'blink-cmp-menu'
            end,
            on_finished = function()
                if key_state.mouse_scroll then
                    key_state.mouse_scroll = false
                elseif key_state.hlsearch then
                    key_state.hlsearch = false
                    if utils.cursor_in_match() then vim.cmd('set hlsearch') end
                elseif key_state.diagnostic then
                    key_state.diagnostic = false
                    local cursor = vim.api.nvim_win_get_cursor(0)
                    if cursor[1] == 1 and cursor[2] == 0 then
                        vim.schedule(
                            function() utils.feedkeys('w<cmd>Lspsaga diagnostic_jump_prev<cr>', 'n') end
                        )
                    else
                        vim.schedule(
                            function() utils.feedkeys('b<cmd>Lspsaga diagnostic_jump_next<cr>', 'n') end
                        )
                    end
                end
            end,
        },
        statuscolumn = { enabled = false },
        words = { enabled = true },
        explorer = { enabled = false },
        ---@type table<string, snacks.win.Config>
        styles = {
            ---@diagnostic disable-next-line: missing-fields
            terminal = {
                position = 'float',
                border = 'rounded',
                keys = {
                    q = false,
                    gf = false,
                    term_normal = false,
                },
            },
        },
        notifier = { enabled = false },
        quickfile = { enabled = true },
    },
    keys = {
        {
            '<leader>r',
            function()
                local fullpath = vim.fn.expand('%:p')
                local directory = vim.fn.fnamemodify(fullpath, ':h')
                local filename = vim.fn.fnamemodify(fullpath, ':t')
                local filename_noext = vim.fn.fnamemodify(fullpath, ':t:r')
                local command = ''
                if vim.tbl_contains(vim.g.markdown_support_filetype, vim.bo.filetype) then
                    vim.cmd('RenderMarkdown buf_toggle')
                    return
                elseif vim.bo.filetype == 'c' then
                    command = string.format(
                        'gcc -g -Wall "%s" -I include -o "%s.out" && echo RUNNING && time "./%s.out"',
                        filename,
                        filename_noext,
                        filename_noext
                    )
                elseif vim.bo.filetype == 'cpp' then
                    command = string.format(
                        'g++ -g -Wall -std=c++17 -I include "%s" -o "%s.out" && echo RUNNING && time "./%s.out"',
                        filename,
                        filename_noext,
                        filename_noext
                    )
                elseif vim.bo.filetype == 'java' then
                    command = string.format(
                        'javac "%s" && echo RUNNING && time java "%s"',
                        filename,
                        filename_noext
                    )
                elseif vim.bo.filetype == 'sh' then
                    command = string.format('time "./%s"', filename)
                elseif vim.bo.filetype == 'python' then
                    command = string.format('time python3 "%s"', filename)
                elseif vim.bo.filetype == 'html' then
                    command = vim.fn.executable('wslview')
                            and string.format('wslview "%s" &', filename)
                        or ''
                elseif vim.bo.filetype == 'lua' then
                    command = string.format('time lua "%s"', filename)
                end
                if command == '' then
                    vim.notify('Unsupported filetype', nil, { title = 'Compile and Run' })
                    return
                end
                command = 'cd ' .. directory .. ' && ' .. command
                Snacks.terminal(
                    command,
                    { start_insert = true, auto_insert = true, auto_close = false }
                )
            end,
            desc = 'Run and compile',
        },
        { '<c-y>', function() Snacks.picker.resume() end, desc = 'Resume last picker' },
        {
            '<c-p>',
            function()
                if not vim.fn.executable('rg') then
                    vim.notify('ripgrep (rg) not found on your system', vim.log.levels.WARN)
                    return
                end
                Snacks.picker.files({
                    cmd = 'rg',
                    hidden = not utils.should_ignore_hidden_files(),
                    exclude = file_ignore_patterns,
                    layout = {
                        hidden = { 'preview' },
                    },
                })
            end,
            desc = 'Toggle find Files',
        },
        {
            '<c-f>',
            function()
                if not vim.fn.executable('rg') then
                    vim.notify('ripgrep (rg) not found on your system', vim.log.levels.WARN)
                    return
                end
                Snacks.picker.grep({
                    cwd = vim.fn.getcwd(),
                    limit = live_grep_limit,
                    cmd = 'rg',
                    hidden = not utils.should_ignore_hidden_files(),
                    exclude = file_ignore_patterns,
                })
            end,
            desc = 'Toggle Live Grep',
        },
        {
            'gD',
            function() Snacks.picker.lsp_declarations() end,
            desc = 'Goto Declaration',
        },
        {
            '<leader><leader>',
            function()
                Snacks.picker.lines({
                    layout = {
                        preset = 'select',
                    },
                })
            end,
            desc = 'Current buffer fuzzy find',
        },
        {
            'z=',
            function() Snacks.picker.spelling({ layout = { preset = 'select' } }) end,
            desc = 'Spelling suggestions',
        },
        {
            '<leader>s/',
            function() Snacks.picker.search_history() end,
            desc = 'Search History',
        },
        {
            '<leader>sj',
            function() Snacks.picker.jumps() end,
            desc = 'Jumps',
        },
        {
            '<leader>sd',
            function() Snacks.picker.diagnostics_buffer() end,
            desc = 'Buffer Diagnostics',
        },
        {
            '<leader>sD',
            function() Snacks.picker.diagnostics() end,
            desc = 'Diagnostics',
        },
        {
            '<leader>sw',
            function() Snacks.picker.grep_word() end,
            desc = 'Visual selection or word',
            mode = { 'n', 'x' },
        },
        { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks' },
        {
            '<leader>sM',
            function() Snacks.picker.man() end,
            desc = 'Man Pages',
        },
        {
            '<leader>su',
            function() Snacks.picker.undo() end,
            desc = 'Undo History',
        },
        {
            '<leader>sl',
            function() Snacks.picker.loclist() end,
            desc = 'Location List',
        },
        {
            '<leader>sq',
            function() Snacks.picker.qflist() end,
            desc = 'Quickfix List',
        },
        {
            '<leader>gb',
            function() Snacks.gitbrowse() end,
            desc = 'Git Browse',
            mode = { 'n', 'v' },
        },
        {
            '<leader>si',
            function() Snacks.picker.command_history() end,
            desc = 'Command History',
        },
        { '[w', prev_word_ref, mode = { 'n', 'o', 'x' }, desc = 'Previous word reference' },
        { ']w', next_word_ref, mode = { 'n', 'o', 'x' }, desc = 'Next word reference' },
    },
}
