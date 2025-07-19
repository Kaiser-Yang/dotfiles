vim.g.mason_ensure_installed = vim.g.mason_ensure_installed
    or {
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
return {
    'williamboman/mason.nvim',
    branch = 'v1.x',
    lazy = false,
    config = function()
        local path_before_mason = vim.env.PATH
        require('mason').setup()
        local sources = require('mason-registry.sources')
        for source in sources.iter({ include_uninstalled = true }) do
            for _, package_name in ipairs(vim.g.mason_ensure_installed) do
                local pkg = source:get_package(package_name)
                if pkg and not pkg:is_installed() then pkg:install() end
            end
        end
        if not vim.g.use_mason_bin_first then
            vim.env.PATH = path_before_mason
                .. ':'
                .. vim.env.HOME
                .. '/.local/share/nvim/mason/bin'
        end
    end,
}
