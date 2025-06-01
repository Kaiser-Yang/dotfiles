local disabled_filetype = { 'snacks_picker_input' }
return {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    branch = 'v0.6',
    config = function()
        require('ultimate-autopair').setup({
            bs = {
                overjumps = true, --(|foo) > bs > |foo
                space = 'balance',
                indent_ignore = true,
            },
            cr = {
                autoclose = true,
            },
            space = {
                check_box_ft = vim.g.markdown_support_filetype,
            },
            close = {
                enable = false,
            },
            config_internal_pairs = {
                { '[', ']', dosuround = false, nft = disabled_filetype },
                { '(', ')', dosuround = false, nft = disabled_filetype },
                { '{', '}', dosuround = false, nft = disabled_filetype },
                { '"', '"', nft = disabled_filetype },
                { "'", "'", nft = disabled_filetype },
                { '`', '`', cmap = false, nft = disabled_filetype },
            },
        })
        local map_set = require('utils').map_set
        local auto_pairs = require('ultimate-autopair.core')
        map_set(
            { 'i' },
            '<plug>(ultimate-auto-pairs-cr)',
            auto_pairs.get_run(vim.api.nvim_replace_termcodes('<cr>', true, true, true)),
            { expr = true, replace_keycodes = false }
        )
        map_set(
            { 'i' },
            '<plug>(ultimate-auto-pairs-bs)',
            auto_pairs.get_run(vim.api.nvim_replace_termcodes('<bs>', true, true, true)),
            { expr = true, replace_keycodes = false }
        )
    end,
}
