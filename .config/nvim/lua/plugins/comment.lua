local line_wise_key_wrapper = require('utils').line_wise_key_wrapper
return {
    'numToStr/Comment.nvim',
    dependencies = {
        {
            'JoosepAlviste/nvim-ts-context-commentstring',
            opts = {
                enable_autocmd = false,
            },
        },
    },
    opts = {
        ignore = '^%s*$',
        mappings = false,
        pre_hook = function()
            require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
        end,
    },
    keys = {
        {
            '<space>c',
            '<plug>(comment_toggle_linewise)',
            desc = 'Comment toggle linewise',
        },
        {
            '<space>c<space>',
            line_wise_key_wrapper('<f37>', false, 'm'),
            desc = 'Comment toggle current line',
        },
        {
            '<space>c',
            '<Plug>(comment_toggle_linewise_visual)',
            mode = 'x',
            desc = 'Comment toggle linewise (visual)',
        },
        { '<space>C', '<Plug>(comment_toggle_blockwise)', desc = 'Comment toggle blockwise' },
        {
            '<space>Cb',
            line_wise_key_wrapper('<f38>', false, 'm'),
            desc = 'Comment toggle current block',
        },
        {
            '<space>C',
            '<Plug>(comment_toggle_blockwise_visual)',
            mode = 'x',
            desc = 'Comment toggle blockwise (visual)',
        },
        { '<m-/>', '<space>c<space>', desc = 'Toggle comment for current line', remap = true },
        {
            '<m-/>',
            '<space>c',
            mode = 'x',
            remap = true,
            desc = 'Toggle comment for selected lines',
        },
        {
            '<m-/>',
            function()
                local before_line = vim.api.nvim_get_current_line()
                local content_after_cursor = before_line:sub(vim.fn.col('.'))
                local content_before_cursor = before_line:sub(1, vim.fn.col('.') - 1)
                vim.schedule(function()
                    local current_line = vim.api.nvim_get_current_line()
                    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                    local after_col, before_col, first_neq_col
                    -- check if current_line ends with content_after_cursor
                    if current_line:sub(-#content_after_cursor) == content_after_cursor then
                        after_col = #current_line - #content_after_cursor
                    end
                    if current_line:sub(1, #content_before_cursor) == content_before_cursor then
                        before_col = #content_before_cursor
                    end
                    for i = 1, #current_line do
                        if current_line:sub(i, i) ~= before_line:sub(i, i) then
                            first_neq_col = i - 1
                            break
                        end
                    end
                    col = after_col or before_col or first_neq_col or col
                    vim.api.nvim_win_set_cursor(0, { row, col })
                end)
                return '<c-o><space>c<space>'
            end,
            mode = 'i',
            desc = 'Toggle comment for current line',
            expr = true,
            remap = true,
        },
        {
            '<space>co',
            function() require('Comment.api').insert.linewise.below() end,
            desc = 'Comment insert below',
        },
        {
            '<space>cO',
            function() require('Comment.api').insert.linewise.above() end,
            desc = 'Comment insert above',
        },
        {
            '<space>cA',
            function() require('Comment.api').locked('insert.linewise.eol')() end,
            desc = 'Comment insert end of line',
        },
        {
            '<f37>',
            function()
                -- vim.notify(tostring(vim.v.count))
                if vim.v.count == 0 then
                    return '<plug>(comment_toggle_linewise_current)'
                else
                    return '<plug>(comment_toggle_linewise_count)'
                end
            end,
            expr = true,
            desc = 'This key is a indirect key for line wise comment',
        },
        {
            '<f38>',
            function()
                if vim.v.count == 0 then
                    return '<Plug>(comment_toggle_blockwise_current)'
                else
                    return '<Plug>(comment_toggle_blockwise_count)'
                end
            end,
            expr = true,
            desc = 'This key is a indirect key for line wise block comment',
        },
    },
}
