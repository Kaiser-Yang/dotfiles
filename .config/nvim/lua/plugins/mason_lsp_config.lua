return {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
        "williamboman/mason.nvim",
    },
    opts = {
        ensure_installed = {
            "clangd",
            "cmake",
            "pyright",
            "lua_ls",
            "ts_ls",
            "jdtls",
            "jsonls",
            "lemminx", -- xml lsp
            "yamlls",
            "vuels",
            "bashls",
            "markdown_oxide",
            -- FIX: this will fail: cargo failed with...
            -- "gitlab_ci_ls",
        },
        automatic_installation = true
    }
}
