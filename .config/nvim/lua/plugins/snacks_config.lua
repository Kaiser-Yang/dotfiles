local utils = require('utils')
local map_set = utils.map_set
local file_ignore_patterns = {
    '%.git',
    '%.root',
    '%.o',
    '%.out',
    '%.exe',
    '%.png',
    '%.gif',
    '%.jpg',
    '%.so',
    '%.a',
    '%.dll',
    '%.dylib',
    '%.class',
    '%.jar',
    '%.zip',
    '%.tar.gz',
    '3rdparty',
}
return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    dependencies = {
        'HakonHarnes/img-clip.nvim',
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/nvim-treesitter',
        'MeanderingProgrammer/render-markdown.nvim',
    },
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
        bigfile = {
            enabled = true,
            size = vim.g.big_file_limit,
        },
        dashboard = {
            enabled = false,
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
                    max_size = vim.g.big_file_limit,
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
                        ['<c-j>'] = { 'list_down', mode = { 'i' } },
                        ['<c-k>'] = { 'list_up', mode = { 'i' } },
                        ['<c-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
                        ['<c-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
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
                        ['<a-w>'] = { 'toggle_focus', mode = { 'i', 'n' } },
                        ['<a-m>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
                        ['<a-p>'] = { 'toggle_preview', mode = { 'i', 'n' } },
                        -- Toggle whether or not follow link file
                        ['<a-f>'] = { 'toggle_follow', mode = { 'i', 'n' } },
                        ['<a-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
                        ['<a-d>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
                        ['<c-a>'] = { 'select_all', mode = { 'n', 'i' } },
                        ['<tab>'] = { 'select_and_next', mode = { 'i', 'n' } },
                        ['<s-tab>'] = { 'select_and_prev', mode = { 'i', 'n' } },
                        ['?'] = 'toggle_help_input',
                        ['G'] = 'list_bottom',
                        ['gg'] = 'list_top',
                        ['j'] = 'list_down',
                        ['k'] = 'list_up',
                        ['q'] = 'close',
                        ['<esc>'] = 'cancel',
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
                        ['<a-g>'] = false,
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
                        ['<c-a>'] = 'select_all',
                        ['<tab>'] = 'select_and_next',
                        ['<s-tab>'] = 'select_and_prev',
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
        scope = {
            enabled = false,
        },
        scroll = {
            enabled = true,
            filter = function(buf)
                return vim.g.snacks_scroll ~= false
                    and vim.b[buf].snacks_scroll ~= false
                    and vim.bo[buf].buftype ~= 'terminal'
                    and vim.bo[buf].filetype ~= 'blink-cmp-menu'
            end,
        },
        statuscolumn = {
            enabled = true,
            left = { 'mark', 'sign', 'git' },
            right = { 'fold' },
            folds = {
                open = true,
            },
        },
        words = {
            enabled = true,
        },
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
        notifier = {
            enabled = false,
        },
        quickfile = { enabled = true },
    },

    keys = {
        {
            '<leader>sp',
            function()
                Snacks.picker.files({
                    ft = { 'jpg', 'jpeg', 'png', 'webp' },
                    confirm = function(self, item, _)
                        self:close()
                        require('img-clip').paste_image({}, './' .. item.file)
                    end,
                })
            end,
            desc = 'Paste image from file',
            mode = { 'n' },
        },
        {
            '<c-g>',
            function() Snacks.lazygit() end,
            desc = 'Toggle Lazygit',
            mode = { 'n', 't' },
        },
        { '<c-t>', function() Snacks.terminal() end, desc = 'Toggle Terminal' },
        { '<c-t>', '<cmd>close<cr>', desc = 'Toggle Terminal', mode = { 't' } },
        {
            '<c-y>',
            function() Snacks.picker.resume() end,
            desc = 'Resume last picker',
        },
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
        {
            '<c-p>',
            function()
                Snacks.picker.files({
                    cwd = vim.fn.getcwd(),
                    hidden = true,
                    exclude = file_ignore_patterns,
                })
            end,
            desc = 'Toggle find Files',
        },
        {
            '<c-f>',
            function()
                Snacks.picker.grep({
                    cwd = vim.fn.getcwd(),
                    hidden = true,
                    exclude = file_ignore_patterns,
                })
            end,
            desc = 'Toggle Live Grep',
        },
        {
            '<leader>gb',
            function() Snacks.gitbrowse() end,
            desc = 'Git Browse',
            mode = { 'n', 'v' },
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
            '<leader>sc',
            function() Snacks.picker.command_history() end,
            desc = 'Command History',
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
    },
    init = function()
        vim.api.nvim_create_autocmd('User', {
            pattern = 'VeryLazy',
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...) Snacks.debug.inspect(...) end
                _G.bt = function() Snacks.debug.backtrace() end
                vim.print = _G.dd -- Override print to use snacks for `:=` command
                -- Create some toggle mappings
                Snacks.toggle
                    .option(
                        'conceallevel',
                        { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }
                    )
                    :map('<leader>uc')
                Snacks.toggle.diagnostics():map('<leader>ud')
                Snacks.toggle.treesitter():map('<leader>ut')
            end,
        })
        vim.api.nvim_create_autocmd('FileType', {
            pattern = {
                'snacks_picker_list',
                'snacks_picker_input',
                'snacks_picker_preview',
            },
            callback = function()
                map_set(
                    { 'i' },
                    '<c-p>',
                    function()
                        Snacks.picker.files({
                            cwd = vim.fn.getcwd(),
                            hidden = true,
                            exclude = file_ignore_patterns,
                        })
                    end,
                    { buffer = true }
                )
                map_set(
                    { 'i' },
                    '<c-f>',
                    function()
                        Snacks.picker.grep({
                            cwd = vim.fn.getcwd(),
                            hidden = true,
                            exclude = file_ignore_patterns,
                        })
                    end,
                    { buffer = true }
                )
            end,
        })
        local next_ref_repeat, prev_rev_repeat = require(
            'nvim-treesitter.textobjects.repeatable_move'
        ).make_repeatable_move_pair(
            function() Snacks.words.jump(vim.v.count1) end,
            function() Snacks.words.jump(-vim.v.count1) end
        )
        map_set({ 'n', 't' }, ']w', next_ref_repeat, { desc = 'Next word reference' })
        map_set({ 'n', 't' }, '[w', prev_rev_repeat, { desc = 'Previous word reference' })
    end,
}
