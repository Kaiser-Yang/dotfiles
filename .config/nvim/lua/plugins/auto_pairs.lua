-- vim.keymap.set('i', '<plug>(test)', '')
return {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    branch = 'v0.6',
    config = function()
        require('ultimate-autopair').setup({
            cmap = false,
            bs = {
                overjumps = false,
                space = 'balance',
                indent_ignore = true,
            },
            cr = {
                map = { '<cr>' },
                autoclose = true,
            },
            space = {
                check_box_ft = vim.g.markdown_support_filetype,
            },
            fastwarp = {
                enable = false,
            },
            close = {
                enable = false,
            },
            config_internal_pairs = {
                { '[', ']', fly = true, dosuround = false, newline = true, space = true },
                { '(', ')', fly = true, dosuround = false, newline = true, space = true },
                { '{', '}', fly = true, dosuround = false, newline = true, space = true },
            }
        })
        local map_set = require('utils').map_set
        local auto_pairs = require('ultimate-autopair.core')
        map_set({ 'i' }, '<plug>(ultimate-auto-pairs-cr)',
            auto_pairs.get_run(vim.api.nvim_replace_termcodes('<cr>', true, true, true)),
            { expr = true, replace_keycodes = false })
        map_set({ 'i' }, '<plug>(ultimate-auto-pairs-bs)',
            auto_pairs.get_run(vim.api.nvim_replace_termcodes('<bs>', true, true, true)),
            { expr = true, replace_keycodes = false })
    end
}
