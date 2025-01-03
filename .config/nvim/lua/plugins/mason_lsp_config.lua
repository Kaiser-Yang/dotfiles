return {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
        'williamboman/mason.nvim',
    },
    opts = {
        ensure_installed = {
            'clangd',
            'cmake',
            'pyright',
            'lua_ls',
            'ts_ls',
            'jdtls',
            'jsonls',
            'lemminx', -- xml lsp
            'yamlls',
            'volar', -- vue language server
            'bashls',
        },
        automatic_installation = true
    }
}
