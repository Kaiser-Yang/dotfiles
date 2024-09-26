local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
require('java').setup({
    capabilities = lsp_capabilities,
    root_markers = {
        '.root',
        '.git',
        'settings.gradle',
        'settings.gradle.kts',
        'pom.xml',
        'build.gradle',
        'mvnw',
        'gradlew',
        'build.gradle',
        'build.gradle.kts'
    },
    jdk = {
        auto_install = false,
    },
})
require'lspconfig'.jdtls.setup{
    capabilities = lsp_capabilities,
    handlers = {
        -- By assigning an empty function, you can remove the notifications
        -- printed to the cmd
        ["$/progress"] = function(_, _, _) end,
    },
}
require'lspconfig'.pyright.setup{
    capabilities = lsp_capabilities
}
require'lspconfig'.lua_ls.setup{
    capabilities = lsp_capabilities,
    handlers = {
        -- By assigning an empty function, you can remove the notifications
        -- printed to the cmd
        ["$/progress"] = function(_, _, _) end,
    },
}
require'lspconfig'.cmake.setup{
    capabilities = lsp_capabilities
}
require'lspconfig'.ts_ls.setup{
    capabilities = lsp_capabilities
}
require'lspconfig'.clangd.setup{
    capabilities = lsp_capabilities
}
require'lspconfig'.jsonls.setup{
    capabilities = lsp_capabilities
}
require'lspconfig'.lemminx.setup{
    capabilities = lsp_capabilities
}
require'lspconfig'.bashls.setup{
    capabilities = lsp_capabilities
}
require'lspconfig'.markdown_oxide.setup{
    capabilities = lsp_capabilities
}
require'rime-ls'.setup_rime()
vim.diagnostic.config({
    update_in_insert = true,
    virtual_text = false,
    signs = true,
    underline = true,
})
