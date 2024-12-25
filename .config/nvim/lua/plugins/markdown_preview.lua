return {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = vim.g.markdown_support_filetype,
    init = function()
        vim.g.mkdp_auto_close = 0
        vim.g.mkdp_filetypes = vim.g.markdown_support_filetype
        local map_set = require('utils').map_set
        vim.api.nvim_create_autocmd('FileType', {
            pattern = vim.g.markdown_support_filetype,
            group = 'UserDIY',
            callback = function()
                map_set({ 'n' }, '<leader>r', '<cmd>MarkdownPreview<cr>',
                    { desc = 'Compile and run', buffer = true })
            end
        })
    end,
}
