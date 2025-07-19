return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'aznhe21/actions-preview.nvim',
        'mfussenegger/nvim-jdtls',
    },
    lazy = false,
    config = function()
        vim.lsp.config('*', {
            capabilities = require('utils').get_lsp_capabilities(),
            root_markers = vim.g.root_markers,
        })
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
    end,
}
