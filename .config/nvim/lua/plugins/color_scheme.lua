return {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    opts = {
        flavour = 'mocha',
        integrations = {
            blink_cmp = true,
            lsp_saga = true,
            mason = true,
            noice = true,
            notify = true,
            nvim_surround = true,
            which_key = true,
        },
        highlight_overrides = {
            mocha = function(mocha)
                return {
                    IblScope = { fg = mocha.none, style = { 'bold' } },
                    BlinkCmpMenuSelection = { fg = mocha.base, bg = mocha.blue },
                }
            end,
        },
    },
    config = function(_, opts)
        require('catppuccin').setup(opts)
        vim.cmd.colorscheme('catppuccin')
        vim.api.nvim_set_hl(0, 'Folded', { fg = '#89b4fa', bg = 'NONE', force = true })
    end,
}
