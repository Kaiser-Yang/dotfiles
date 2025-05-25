return {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
        require('catppuccin').setup({
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
        })
        vim.cmd.colorscheme('catppuccin')
    end,
}
