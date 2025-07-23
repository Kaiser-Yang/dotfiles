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
        -- We set signs and highlight after colorscheme
        -- to make sure that the colorscheme does not overwrite our settings
        for _, hl in ipairs(require('appearance.highlight')) do
            vim.api.nvim_set_hl(unpack(hl))
        end
        for _, sign in ipairs(require('appearance.sign')) do
            vim.fn.sign_define(unpack(sign))
        end
        -- Run after plugins are loaded, so that the signs and highlights are set
        require('foldsign')
    end,
}
