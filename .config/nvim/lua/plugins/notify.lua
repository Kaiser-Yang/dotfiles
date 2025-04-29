return {
    'rcarriga/nvim-notify',
    config = function()
        vim.notify = require('notify')
        ---@diagnostic disable-next-line: missing-fields, undefined-field
        vim.notify.setup({
            timeout = 1000,
        })
    end,
}
