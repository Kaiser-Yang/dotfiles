local utils = require('utils')
utils.init_for_wsl()
return {
    'Kaiser-Yang/img-clip.nvim',
    branch = 'main',
    ft = vim.g.markdown_support_filetype,
    opts = {
        default = {
            prompt_for_file_name = false,
            embed_image_as_base64 = false,
            dir_path = function()
                local res = 'assets/'
                if utils.current_file_in_github_io() then
                    res = res .. 'img/'
                else
                    res = res .. vim.fn.expand('%:t') .. '/'
                end
                return res
            end,
            drag_and_drop = {
                enabled = utils.markdown_support_enabled,
                insert_mode = utils.markdown_support_enabled,
                use_absolute_path = vim.fn.has('win32') == 1,
            },
        },
        filetypes = {
            markdown = {
                template = function()
                    local res = '![$CURSOR]($FILE_PATH)'
                    if utils.current_file_in_github_io() then res = res .. '{: .img-fluid}' end
                    res = res .. '<++>'
                    return res
                end,
            },
        },
    },
}
