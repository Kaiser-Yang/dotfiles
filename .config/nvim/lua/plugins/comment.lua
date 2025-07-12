local utils = require('utils')
local map_set = utils.map_set
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
    config = function()
        require('Comment').setup({
            -- Add a space b/w comment and the line
            padding = true,
            -- Whether the cursor should stay at its position
            sticky = true,
            -- Lines to be ignored while (un)comment
            ---@diagnostic disable-next-line: assign-type-mismatch
            ignore = nil,
            -- LHS of toggle mappings in NORMAL mode
            toggler = {
                line = '<space>c<space>',
                block = '<space>cs',
            },
            -- LHS of operator-pending mappings in NORMAL and VISUAL mode
            opleader = {
                line = '<space>c',
                block = 'gb',
            },
            -- LHS of extra mappings
            extra = {
                above = '<space>cO',
                below = '<space>co',
                eol = '<space>cA',
            },
            mappings = {
                basic = true,
                extra = true,
            },
            pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            post_hook = function(_) end,
        })
        map_set(
            { 'n' },
            '<m-/>',
            '<space>c<space>',
            { desc = 'Toggle comment for current line', remap = true }
        )
        map_set({ 'i' }, '<m-/>', function()
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
        end, { desc = 'Toggle comment for current line', remap = true, expr = true })
        map_set(
            { 'x' },
            '<m-/>',
            '<space>c',
            { desc = 'Toggle comment for selected lines', remap = true }
        )
    end,
}
