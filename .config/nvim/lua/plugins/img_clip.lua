return {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    keys = {
        {
            '<C-RightMouse>',
            '<cmd>PasteImage<cr>',
            mode = { 'i', 'n' },
            desc = 'Paste image from system clipboard'
        },
    },
    opts = {
        dir_path = function()
            return vim.fn.expand('%:t:r') .. '.assets'
        end,
        filetypes = {
            markdown = {
                template = '![$CURSOR]($FILE_PATH){: .img-fluid}',
            }
        }
    },
}
