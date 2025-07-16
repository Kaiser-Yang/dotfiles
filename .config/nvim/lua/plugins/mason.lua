return {
    'williamboman/mason.nvim',
    branch = 'v1.x',
    config = function()
        local path_before_mason = vim.env.PATH
        require('mason').setup()
        local mason_plugins = {
            'bash-language-server',
            'clangd',
            'shellcheck',
            'clang-format',
            'jdtls',
            'java-debug-adapter',
            'java-test',
            'google-java-format',
            'lua-language-server',
            'stylua',
            'pyright',
            'autopep8',
            'markdown-oxide',
            'eslint-lsp',
            'json-lsp',
            'lemminx',
            'neocmakelsp',
            'tailwindcss-language-server',
            'typescript-language-server',
            'vue-language-server',
            'yaml-language-server',
            'prettier',
            'buildifier',
            'bazelrc-lsp',
            'codelldb',
        }
        local mason_registry = require('mason-registry')
        for _, plugin in ipairs(mason_plugins) do
            local mason_package = mason_registry.get_package(plugin)
            if not mason_package:is_installed() then mason_package:install() end
        end
        -- Make sure mason's bin directory is at the last in the PATH
        vim.env.PATH = path_before_mason .. ':' .. vim.env.HOME .. '/.local/share/nvim/mason/bin'
    end
}
