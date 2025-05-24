return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'saghen/blink.cmp',
        'nvim-java/nvim-java',
        'aznhe21/actions-preview.nvim',
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
            'vue_ls',
            'yamlls',
            'markdown_oxide',
        })
        local map_set = require('utils').map_set
        map_set(
            { 'v', 'n' },
            'ga',
            require('actions-preview').code_actions,
            { desc = 'Code action' }
        )
        map_set({ 'n' }, '<leader>d', 'K', { desc = 'Hover document', remap = true })
    end,
}
