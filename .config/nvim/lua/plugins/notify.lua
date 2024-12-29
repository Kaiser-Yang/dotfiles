return {
    'rcarriga/nvim-notify',
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        vim.notify = require('notify')
        ---@diagnostic disable-next-line: missing-fields
        vim.notify.setup({
            timeout = 1000,
        })
        require('telescope').load_extension('notify')
    end,
}
