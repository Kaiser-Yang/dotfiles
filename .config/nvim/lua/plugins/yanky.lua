local utils = require('utils')
return {
    'gbprod/yanky.nvim',
    opts = {
        picker = {
            highlight = {
                on_yank = true,
                on_put = true,
                timer = 50,
            },
        },
    },
    event = { 'TextYankPost' },
    keys = {
        { mode = { 'n', 'x' }, 'y', '<plug>(YankyYank)' },
        { mode = { 'n', 'x' }, 'p', '<plug>(YankyPutAfter)' },
        { mode = { 'n', 'x' }, 'P', '<plug>(YankyPutBefore)' },
        { mode = { 'n', 'x' }, 'gp', '<plug>(YankyGPutAfter)' },
        { mode = { 'n', 'x' }, 'gP', '<plug>(YankyGPutBefore)' },
        {
            mode = { 'n', 'x' },
            'gy',
            function()
                if not Snacks then return end
                Snacks.picker.yanky({
                    on_show = function() vim.cmd.stopinsert() end,
                })
            end,
        },
        { 'Y', 'y$', desc = 'Yank till eol' },
        { '<m-c>Y', '"+y$', desc = 'Copy till eol to + reg' },
        { '<leader>Y', '"+y$', desc = 'Yank till eol to + reg' },
        {
            '<leader>y',
            function()
                vim.api.nvim_create_autocmd('TextYankPost', {
                    group = 'UserDIY',
                    pattern = '*',
                    callback = function()
                        local anonymous_reg_content = vim.fn.getreg('"')
                        vim.fn.setreg('+', anonymous_reg_content, vim.fn.getregtype('+'))
                    end,
                    once = true,
                })
                return '<plug>(YankyYank)'
            end,
            desc = 'Yank to + reg',
            expr = true,
            mode = { 'n', 'x' },
        },
        { '<m-c>', '<leader>y', desc = 'Copy to + reg', remap = true, mode = { 'n', 'x' } },
        {
            mode = { 'n', 'x', 'i' },
            '<c-rightmouse>',
            function()
                local res
                if not utils.should_enable_paste_image() then
                    local plus_reg_content = vim.fn.getreg('+'):gsub('\r', '')
                    vim.fn.setreg('+', plus_reg_content)
                    vim.fn.setreg('"', plus_reg_content)
                    if vim.fn.mode() == 'i' then
                        local current_line = vim.api.nvim_get_current_line()
                        if current_line:match('^%s*$') then
                            -- HACK:
                            -- if current line is empty, when leaving insert mode,
                            -- the leading whitespace will be removed.
                            -- Therefore, it is hard to do the paste highlight,
                            -- in order to keep the leading whitespace,
                            -- we must use '<c-r>+' to read from the + register directly.
                            -- Maybe we can set a highlight manually in future.
                            vim.cmd('set paste')
                            vim.schedule(function() vim.cmd('set nopaste') end)
                            res = '<c-r>+'
                        else
                            local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
                            local line_len = #current_line
                            res = '<c-g>u<c-o><plug>(YankyPut'
                                .. (line_len == cursor_col and 'After' or 'Before')
                                .. 'Charwise)'
                            if plus_reg_content:sub(-1) == '\n' then
                                plus_reg_content = plus_reg_content:sub(1, -2)
                            end
                            local _, paste_line_num = string.gsub(plus_reg_content, '\n', '')
                            local last_paste_line_len = #plus_reg_content:match('([^\n]*)$')
                            cursor_row = cursor_row + paste_line_num
                            if paste_line_num == 0 then
                                cursor_col = cursor_col + last_paste_line_len
                            else
                                cursor_col = last_paste_line_len
                            end
                            vim.schedule(
                                function()
                                    vim.api.nvim_win_set_cursor(0, { cursor_row, cursor_col })
                                end
                            )
                        end
                    else
                        res = '<plug>(YankyPutAfter)'
                    end
                else
                    local current_line = vim.api.nvim_get_current_line()
                    if
                        not current_line
                        or #current_line == 0
                        or current_line:find('^%s*$') ~= nil
                    then
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
            end,
            desc = 'Paste from + reg',
            expr = true,
        },
        {
            mode = { 'n', 'x', 'i' },
            '<m-v>',
            '<c-rightmouse>',
            desc = 'Paste from + reg',
            remap = true,
        },
        { '<m-v>', '<c-r>+', desc = 'Paste from + reg in command line', mode = 'c' },
        {
            mode = { 'n', 'x' },
            '<leader>p',
            function()
                if not utils.should_enable_paste_image() then
                    local plus_reg_content = vim.fn.getreg('+'):gsub('\r', '')
                    vim.fn.setreg('+', plus_reg_content)
                    vim.fn.setreg('"', plus_reg_content)
                    return '<plug>(YankyPutAfter)'
                else
                    return '<cmd>PasteImage<cr>'
                end
            end,
            desc = 'Paste from clipboard',
            expr = true,
        },
        {
            mode = { 'n', 'x' },
            '<leader>P',
            function()
                local plus_reg_content = vim.fn.getreg('+'):gsub('\r', '')
                if not utils.should_enable_paste_image() then
                    vim.fn.setreg('+', plus_reg_content, vim.fn.getregtype('+'))
                    vim.fn.setreg('"', plus_reg_content, vim.fn.getregtype('"'))
                    return '<plug>(YankyPutBefore)'
                else
                    require('img-clip').paste_image({ insert_template_after_cursor = false })
                end
            end,
            desc = 'Paste from clipboard',
            expr = true,
        },
    },
    -- TODO:
    -- map_set({ 'n' }, ']p', '<plug>(YankyPutIndentAfterLinewise)')
    -- map_set({ 'n' }, ']P', '<plug>(YankyPutIndentAfterLinewise)')
    -- map_set({ 'n' }, '[p', '<plug>(YankyPutIndentBeforeLinewise)')
    -- map_set({ 'n' }, '[P', '<plug>(YankyPutIndentBeforeLinewise)')
    -- map_set({ 'n' }, '>p', '<plug>(YankyPutIndentAfterShiftRight)')
    -- map_set({ 'n' }, '<p', '<plug>(YankyPutIndentAfterShiftLeft)')
    -- map_set({ 'n' }, '>P', '<plug>(YankyPutIndentBeforeShiftRight)')
    -- map_set({ 'n' }, '<P', '<plug>(YankyPutIndentBeforeShiftLeft)')
    -- map_set({ 'n' }, '=p', '<plug>(YankyPutAfterFilter)')
    -- map_set({ 'n' }, '=P', '<plug>(YankyPutBeforeFilter)')
    -- map_set('n', '<c-p>', '<plug>(YankyPreviousEntry)')
    -- map_set('n', '<c-n>', '<plug>(YankyNextEntry)')
}
