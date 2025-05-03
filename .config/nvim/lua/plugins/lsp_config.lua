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
        lsp_capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }
        local default = require('lspconfig').util.default_config
        default.capabilities = vim.tbl_deep_extend('force', default.capabilities, lsp_capabilities)
        vim.lsp.config('*', { root_markers = vim.g.root_markers })
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
