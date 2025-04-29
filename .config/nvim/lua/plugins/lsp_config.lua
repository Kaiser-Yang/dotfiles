return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'saghen/blink.cmp',
        'nvim-java/nvim-java',
    },
    config = function()
        local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
        lsp_capabilities = require('blink.cmp').get_lsp_capabilities(lsp_capabilities)
        local default = require('lspconfig').util.default_config
        default.capabilities = vim.tbl_deep_extend('force', default.capabilities, lsp_capabilities)
        vim.lsp.config('*', {
            root_markers = vim.g.root_markers,
        })
        require('java').setup({
            capabilities = lsp_capabilities,
            root_markers = vim.g.root_markers,
            jdk = {
                auto_install = false,
            },
        })
        vim.lsp.enable({
            'bashls',
            'clangd',
            'eslint',
            'jdtls',
            'jsonls',
            'lemminx',
            'lua_ls',
            'neocmake',
            'pyright',
            'rime_ls',
            'tailwindcss',
            'ts_ls',
            'volar',
            'yamlls',
        })
    end,
}
