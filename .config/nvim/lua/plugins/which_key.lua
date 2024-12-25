return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
        require('which-key').setup({
            delay = vim.o.timeoutlen,
            sort = { "alphanum", "local", "order", "group", "mod" }
        })
    end,
}
