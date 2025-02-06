return {
    "sphamba/smear-cursor.nvim",
    config = function()
        require('smear_cursor').setup({
            smear_to_cmd = false,
        })
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'bigfile*,toggleterm',
            group = 'UserDIY',
            callback = function()
                require('smear_cursor').enabled = false
                -- when leaving the buffer, enable smear_cursor
                vim.api.nvim_create_autocmd('BufLeave', {
                    pattern = '<buffer>',
                    group = 'UserDIY',
                    callback = function()
                        require('smear_cursor').enabled = true
                    end,
                    once = true
                })
            end
        })
    end
}
