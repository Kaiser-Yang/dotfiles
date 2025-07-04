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
            '',
            '<space>c<space>',
            { desc = 'Toggle comment for current line', remap = true }
        )
        map_set(
            { 'x' },
            '',
            '<space>c',
            { desc = 'Toggle comment for selected lines', remap = true }
        )
    end,
}
