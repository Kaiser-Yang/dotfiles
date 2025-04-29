return {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
        require('catppuccin').setup({
            flavour = 'mocha',
            integrations = {
                blink_cmp     = true,
                lsp_saga      = true,
                mason         = true,
                noice         = true,
                notify        = true,
                nvim_surround = true,
                illuminate    = true,
                which_key     = true,
            },
            highlight_overrides = {
                mocha = function(mocha)
                    return {
                        IblScope = { fg = mocha.none, style = { 'bold' } },
                        BlinkCmpMenuSelection = { fg = mocha.base, bg = mocha.blue },
                    }
                end
            }
        })
        local sign = vim.fn.sign_define
        sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
        sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
        sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
        vim.cmd.colorscheme('catppuccin')
    end
}
