return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'saghen/blink.cmp',
            'aznhe21/actions-preview.nvim',
            {

                'mfussenegger/nvim-jdtls',
                dependencies = {
                    'mfussenegger/nvim-dap',
                },
            },
        },
        config = function()
            vim.lsp.config('*', { root_markers = vim.g.root_markers })
            vim.lsp.enable({
                'bashls',
                'clangd',
                'eslint',
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
    },
}
