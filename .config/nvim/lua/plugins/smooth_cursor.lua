return {
    "sphamba/smear-cursor.nvim",
    config = function()
        require('smear_cursor').setup({
            smear_to_cmd = false,
            filetypes_disabled = {
                'toggleterm',
            },
            smear_insert_mode = false,
        })
    end
}
