return {
    capabilities = require('utils').get_lsp_capabilities(),
    handlers = {
        ['$/progress'] = function(_, _, _) end,
    },
    settings = {
        Lua = {
            completion = {
                callSnippet = 'Disable',
                keywordSnippet = 'Disable',
            },
        },
    },
}
