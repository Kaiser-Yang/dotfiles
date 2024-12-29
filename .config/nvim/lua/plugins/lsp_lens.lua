return {
    'VidocqH/lsp-lens.nvim',
    dependencies = {
        'neovim/nvim-lspconfig',
    },
    cmd = { 'LspLenOn', 'LspLenOff', 'LspLensToggle' },
    keys = {
        {
            'gcl',
            '<cmd>LspLensToggle<cr>',
            mode = 'n',
            silent = true,
            noremap = true,
            desc = 'Toggle LSP lens',
        }
    },
    config = true,
}
