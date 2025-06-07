return {
    'stevearc/conform.nvim',
    cmd = { 'ConformInfo' },
    keys = {
        {
            '<leader>f',
            function()
                local feedkeys = require('utils').feedkeys
                require('conform').format({ async = true, lsp_format = 'fallback' }, function()
                    local mode = vim.api.nvim_get_mode().mode
                    if mode == 'v' or mode == 'V' then feedkeys('<esc>', 'n') end
                end)
            end,
            mode = { 'n', 'v' },
            desc = 'Format',
            silent = true,
            noremap = true,
        },
    },
    opts = {
        formatters_by_ft = {
            c = { 'clang-format' },
            cpp = { 'clang-format' },
            python = { 'autopep8' },
            java = { 'google-java-format' },
            -- markdown = { 'markdownlint-cli2' },
            lua = { 'stylua' },
            vue = { 'prettier' },
            typescript = { 'prettier' },
            javascript = { 'prettier' },
            css = { 'prettier' },
        },
        formatters = {
            ['autopep8'] = {
                prepend_args = {
                    '--max-line-length',
                    '100',
                },
            },
        },
    },
}
