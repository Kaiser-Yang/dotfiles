local function rime_on_attach(client, _)
    vim.api.nvim_create_user_command('RimeToggle', function()
        client.request('workspace/executeCommand',
            { command = 'rime-ls.toggle-rime' },
            function(_, result, ctx, _)
                if ctx.client_id == client.id then
                    vim.g.rime_enabled = result
                end
            end
        )
    end, { nargs = 0 })

    local mapped_punc = {
        [','] = '，',
        ['.'] = '。',
        [':'] = '：',
        ['?'] = '？',
        ['\\'] = '、'
        -- FIX: can not work now
        -- [';'] = '；',
    }

    -- auto accept when there is only one rime item after inputting a number
    require('blink.cmp.completion.list').show_emitter:on(function(event)
        if not vim.g.rime_enabled then return end
        local col = vim.fn.col('.') - 1
        if event.context.line:sub(col, col):match('%d') == nil then return end
        local rime_item_index = require('plugins.rime_ls').get_n_rime_item_index(2, event.items)
        if #rime_item_index ~= 1 then return end
        require('blink.cmp').accept({ index = rime_item_index[1] })
    end)

    local map_set = require('utils').map_set
    local map_del = require('utils').map_del
    -- Toggle rime
    -- This will toggle Chinese punctuations too
    map_set({ 'n', 'i' }, '<c-space>', function()
        -- We must check the status before the toggle
        if vim.g.rime_enabled then
            for k, _ in pairs(mapped_punc) do
                map_del({ 'i' }, k .. '<space>')
            end
        else
            for k, v in pairs(mapped_punc) do
                map_set({ 'i' }, k .. '<space>', v)
            end
        end
        vim.cmd('RimeToggle')
    end)
end
return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'saghen/blink.cmp',
        'nvim-java/nvim-java',
    },
    config = function()
        -- TODO: refactor those code below
        local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
        lsp_capabilities = require('blink.cmp').get_lsp_capabilities(lsp_capabilities)
        require('java').setup({
            capabilities = lsp_capabilities,
            root_markers = vim.g.root_markers,
            jdk = {
                auto_install = false,
            },
        })
        require('plugins.rime_ls').setup({
            filetype = vim.g.rime_ls_support_filetype,
        })
        local lspconfig = require('lspconfig')
        lspconfig.clangd.setup({ capabilities = lsp_capabilities })
        lspconfig.cmake.setup({ capabilities = lsp_capabilities })
        lspconfig.pyright.setup({ capabilities = lsp_capabilities })
        lspconfig.ts_ls.setup({ capabilities = lsp_capabilities })
        lspconfig.jsonls.setup({ capabilities = lsp_capabilities })
        lspconfig.lemminx.setup({ capabilities = lsp_capabilities })
        lspconfig.yamlls.setup({ capabilities = lsp_capabilities })
        lspconfig.volar.setup({ capabilities = lsp_capabilities })
        lspconfig.bashls.setup({ capabilities = lsp_capabilities })
        lspconfig.lua_ls.setup({
            capabilities = lsp_capabilities,
            handlers = {
                -- By assigning an empty function, you can remove the notifications
                -- printed to the cmd
                ['$/progress'] = function(_, _, _) end,
            },
        })
        lspconfig.jdtls.setup({
            capabilities = lsp_capabilities,
            handlers = {
                -- By assigning an empty function, you can remove the notifications
                -- printed to the cmd
                ['$/progress'] = function(_, _, _) end,
            },
        })
        lspconfig.rime_ls.setup({
            init_options = {
                enabled = vim.g.rime_enabled,
                shared_data_dir = '/usr/share/rime-data',
                user_data_dir = vim.fn.expand('~/.local/share/rime-ls'),
                log_dir = vim.fn.expand('~/.local/share/rime-ls'),
                always_incomplete = true,
                long_filter_text = true
            },
            capabilities = lsp_capabilities,
            on_attach = rime_on_attach
        })
    end,
}
