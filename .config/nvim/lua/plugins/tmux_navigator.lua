return {
    'christoomey/vim-tmux-navigator',
    cmd = {
        'TmuxNavigateLeft',
        'TmuxNavigateDown',
        'TmuxNavigateUp',
        'TmuxNavigateRight',
        'TmuxNavigatePrevious',
    },
    keys = {
        {
            '<c-h>',
            '<esc><cmd>TmuxNavigateLeft<cr>',
            mode = { 'n', 'i' },
            silent = true,
            noremap = true,
            desc = 'Navigate to the left pane',
        },
        {
            '<c-j>',
            '<esc><cmd>TmuxNavigateDown<cr>',
            mode = { 'n', 'i' },
            silent = true,
            noremap = true,
            desc = 'Navigate to the bottom pane',
        },
        {
            '<c-k>',
            '<esc><cmd>TmuxNavigateUp<cr>',
            mode = { 'n', 'i' },
            silent = true,
            noremap = true,
            desc = 'Navigate to the top pane',
        },
        {
            '<c-l>',
            '<esc><cmd>TmuxNavigateRight<cr>',
            mode = { 'n', 'i' },
            silent = true,
            noremap = true,
            desc = 'Navigate to the right pane',
        },
    },
    init = function()
        vim.g.tmux_navigator_preserve_zoom = 1
        vim.g.tmux_navigator_disable_when_zoomed = 0
    end
}
