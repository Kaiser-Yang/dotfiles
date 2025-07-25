return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
        delay = vim.o.timeoutlen,
        sort = { 'alphanum', 'local', 'order', 'group', 'mod' },
        plugins = {
            spelling = { enabled = false },
        },
    },
    keys = {
        {
            '<leader>?',
            function() require('which-key').show() end,
            desc = 'Buffer Local Keymaps (which-key)',
        },
        { 's', '<cmd>WhichKey n s<cr>' },
    },
}
