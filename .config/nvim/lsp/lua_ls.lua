return {
    capabilities = require('utils').get_lsp_capabilities(),
    handlers = {
        ['$/progress'] = function(_, _, _) end,
    },
    on_init = function(client)
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                version = 'LuaJIT',
                path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                },
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths
                    -- here.
                    -- '${3rd}/luv/library',
                    -- '${3rd}/busted/library',
                },
            },
        })
    end,
    settings = {
        Lua = {
            completion = {
                callSnippet = 'Disable',
                keywordSnippet = 'Disable',
            },
        },
    },
}
