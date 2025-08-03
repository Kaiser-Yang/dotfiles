-- FIX:
-- Use <c-p> to open file picker,
-- then use <c-f> to switch to grep picker,
-- then <c-p> can not switch back to file picker, unless you press <c-p> twice.
-- When there are more than one window before enterint pickers, and switch to another picker
-- and on confirm may enter the wrong window.
return {
    opts = {
        input = { enabled = false },
    },
    keys = {
        {
            'gD',
            function() Snacks.picker.lsp_declarations() end,
            desc = 'Goto Declaration',
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
            big_file_check_wrapper(function() Snacks.picker.grep_word() end),
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
