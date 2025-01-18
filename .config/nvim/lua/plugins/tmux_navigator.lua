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
            '<cmd><c-u>TmuxNavigateLeft<cr>',
            silent = true,
            noremap = true,
            desc = 'Navigate to the left pane',
        },
        {
            '<c-j>',
            '<cmd><c-u>TmuxNavigateDown<cr>',
            silent = true,
            noremap = true,
            desc = 'Navigate to the bottom pane',
        },
        {
            '<c-k>',
            '<cmd><c-u>TmuxNavigateUp<cr>',
            silent = true,
            noremap = true,
            desc = 'Navigate to the top pane',
        },
        {
            '<c-l>',
            '<cmd><c-u>TmuxNavigateRight<cr>',
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
