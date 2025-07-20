return {
    'neovim/nvim-lspconfig',
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
    end,
}
