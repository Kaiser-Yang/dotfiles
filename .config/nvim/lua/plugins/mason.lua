return {
    'williamboman/mason.nvim',
    branch = 'v1.x',
    lazy = false,
    config = function()
        local path_before_mason = vim.env.PATH
        require('mason').setup()
        local ensured_installed = {
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
        local sources = require('mason-registry.sources')
        for source in sources.iter({ include_uninstalled = true }) do
            for _, package_name in ipairs(ensured_installed) do
                local pkg = source:get_package(package_name)
                if pkg and not pkg:is_installed() then pkg:install() end
            end
        end
        -- Make sure mason's bin directory is at the last in the PATH
        vim.env.PATH = path_before_mason .. ':' .. vim.env.HOME .. '/.local/share/nvim/mason/bin'
    end,
}
