require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup {
    ensure_installed = { "clangd", "cmake", "pyright", "lua_ls", "tsserver", "jdtls", "jsonls",
        "lemminx" },
    automatic_installation = true,
}
