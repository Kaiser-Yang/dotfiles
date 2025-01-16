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
    ft = vim.g.markdown_support_filetype,
    opts = {
        default = {
            dir_path = function()
                return vim.fn.expand('%:t:r') .. '.assets'
            end,
            filetypes = {
                markdown = {
                    template = '![$CURSOR]($FILE_PATH){: .img-fluid}',
                }
            },
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
                insert_mode = true,
            },
        }
    },
}
