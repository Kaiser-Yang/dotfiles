require("mason-lspconfig").setup {
    ensure_installed = {
        "clangd",
        "cmake",
        "pyright",
        "lua_ls",
        "tsserver",
        "jdtls",
        "jsonls",
        "lemminx", -- xml lsp
        "yamlls",
        "vuels",
        "texlab"
        -- FIX: this will fail: cargo failed with...
        -- "gitlab_ci_ls",
    },
    automatic_installation = true
}
