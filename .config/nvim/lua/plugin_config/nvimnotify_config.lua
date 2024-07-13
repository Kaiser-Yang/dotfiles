require("telescope").load_extension("notify")
vim.notify = require('notify')
vim.notify.setup {
    -- render = 'wrapped-compact',
    -- minimum_width = 50,
    -- max_width = 100,
    timeout = 1000,
}
