return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
    },
    ft = vim.g.markdown_support_filetypes,
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        file_types = vim.g.markdown_support_filetypes,
        html = {
            comment = {
                conceal = false,
            }
        }
    },
}
