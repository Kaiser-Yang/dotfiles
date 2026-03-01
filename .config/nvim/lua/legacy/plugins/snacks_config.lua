return {
    keys = {
        {
            'gD',
            function() Snacks.picker.lsp_declarations() end,
            desc = 'Goto Declaration',
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
