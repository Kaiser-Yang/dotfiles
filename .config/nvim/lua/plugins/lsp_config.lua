return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'saghen/blink.cmp',
        'nvim-java/nvim-java',
    },
    config = function()
        require('java').setup({
            jdk = {
                auto_install = false,
            },
            notifications = {
                dap = false,
            },
        })
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
