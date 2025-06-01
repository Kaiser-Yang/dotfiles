return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
    },
    ft = vim.g.markdown_support_filetype,
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        enabled = false,
        file_types = vim.g.markdown_support_filetype,
        anti_conceal = { enabled = false },
        win_options = { concealcursor = { rendered = 'nvic' } },
        on = {
            attach = function()
                if vim.bo.filetype == 'Avante' then
                    vim.cmd('RenderMarkdown buf_enable')
                end
            end,
        }
    },
}
