return {
    'kylechui/nvim-surround',
    version = '*',
    opts = {
        keymaps = {
            insert = false,
            insert_line = false,
            normal = false,
            normal_cur = false,
            normal_line = false,
            normal_cur_line = false,
            visual = false,
            visual_line = false,
            delete = false,
            change = false,
            change_line = false,
        },
    },
    keys = {
        {
            '<c-p>s',
            '<plug>(nvim-surround-insert)',
            mode = 'i',
            desc = 'Add a surrounding pair around the cursor (insert mode)',
        },
        {
            '<c-p>S',
            '<plug>(nvim-surround-insert-line)',
            mode = 'i',
            desc = 'Add a surrounding pair around the cursor, on new lines (insert mode)',
        },
        {
            'ys',
            '<plug>(nvim-surround-normal)',
            desc = 'Add a surrounding pair around a motion (normal mode)',
        },
        {
            'yS',
            '<plug>(nvim-surround-normal-cur)',
            desc = 'Add a surrounding pair around the current line (normal mode)',
        },
        {
            'S',
            '<plug>(nvim-surround-visual)',
            desc = 'Add a surrounding pair around a visual selection',
            mode = 'x',
        },
        {
            'ds',
            '<plug>(nvim-surround-delete)',
            desc = 'Delete a surrounding pair',
        },
        {
            'cs',
            '<plug>(nvim-surround-change)',
            desc = 'Change a surrounding pair',
        },
        {
            's',
            function()
                if vim.v.operator == 'y' then
                    return '<esc><plug>(nvim-surround-normal)'
                elseif vim.v.operator == 'd' then
                    return '<esc><plug>(nvim-surround-delete)'
                elseif vim.v.operator == 'c' then
                    return '<esc><plug>(nvim-surround-change)'
                end
            end,
            expr = true,
            mode = 'o',
            desc = 'Change, delete or add a surrounding pair (operator pending mode)',
        },
        {
            'S',
            function()
                if vim.v.operator == 'y' then return '<esc><plug>(nvim-surround-normal-cur)' end
            end,
            expr = true,
            mode = 'o',
            desc = 'Change, delete or add a surrounding pair (operator pending mode, line-wise)',
        },
    },
}
