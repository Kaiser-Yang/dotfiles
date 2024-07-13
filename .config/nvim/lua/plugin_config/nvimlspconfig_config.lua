-- local function pyright_on_attach(client, bufnr)
--     local function organize_imports()
--         local params = {
--             command = 'pyright.organizeimports',
--             arguments = { vim.uri_from_bufnr(0) },
--         }
--         vim.lsp.buf.execute_command(params)
--     end
--
--     if client.name == "pyright" then
--         vim.api.nvim_create_user_command("PyrightOrganizeImports", organize_imports, {desc = 'Organize Imports'})
--     end
-- end
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
require('java').setup({
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
        ["$/progress"] = function(_, result, ctx) end,
    },
}
require'lspconfig'.pyright.setup{
    capabilities = lsp_capabilities
    -- on_attach = pyright_on_attach,
}
require'lspconfig'.lua_ls.setup{
    capabilities = lsp_capabilities,
    handlers = {
        -- By assigning an empty function, you can remove the notifications
        -- printed to the cmd
        ["$/progress"] = function(_, result, ctx) end,
    },
}
require'lspconfig'.cmake.setup{
    capabilities = lsp_capabilities
}
require'lspconfig'.tsserver.setup{
    capabilities = lsp_capabilities
}
require'lspconfig'.clangd.setup{
    capabilities = lsp_capabilities
    -- on_new_config = function(new_config, new_cwd)
    --     local status, cmake = pcall(require, "cmake-tools")
    --     if status then
    --         cmake.clangd_on_new_config(new_config)
    --     end
    -- end,
}
require'lspconfig'.jsonls.setup{
    capabilities = lsp_capabilities
}
require'lspconfig'.lemminx.setup{
    capabilities = lsp_capabilities
}