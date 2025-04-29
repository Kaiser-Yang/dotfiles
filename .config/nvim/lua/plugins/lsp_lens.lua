local lsp_lens_enable = true
return {
    'VidocqH/lsp-lens.nvim',
    event = 'LspAttach',
    cmd = { 'LspLenOn', 'LspLenOff', 'LspLensToggle' },
    keys = {
        {
            'gcl',
            function()
                if lsp_lens_enable then
                    vim.notify('LSP lens disabled', nil, { title = 'LSP Lens' })
                else
                    vim.notify('LSP lens enabled', nil, { title = 'LSP Lens' })
                end
                lsp_lens_enable = not lsp_lens_enable
                vim.cmd('LspLensToggle')
            end,
            mode = 'n',
            noremap = true,
            desc = 'Toggle LSP lens',
        }
    },
    opts = {
        enable = lsp_lens_enable
    }
}
