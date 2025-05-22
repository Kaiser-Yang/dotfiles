return {
    capabilities = require('utils').get_lsp_capabilities(),
    handlers = {
        ['$/progress'] = function(_, _, _) end,
    }
}
