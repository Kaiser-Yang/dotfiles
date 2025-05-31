return {
    capabilities = require('utils').get_lsp_capabilities(),
    init_options = {
        plugins = {
            {
                name = '@vue/typescript-plugin',
                location = vim.fn.expand(
                    '$MASON/packages/vue-language-server/node_modules/@vue/language-server'
                ),
                languages = { 'vue' },
            },
        },
    },
}
