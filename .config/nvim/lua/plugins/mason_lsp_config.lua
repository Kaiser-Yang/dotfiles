return {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
        'williamboman/mason.nvim',
    },
    opts = {
        ensure_installed = {
            'clangd',
            'neocmake',
            'pyright',
            'lua_ls',
            'jdtls',
            'jsonls',
            'lemminx', -- xml lsp
            'yamlls',
            'volar', -- vue
            'ts_ls', -- typescript
            'eslint', -- javascript
            'tailwindcss', -- css
            'bashls',
        },
        automatic_installation = true
    }
}
