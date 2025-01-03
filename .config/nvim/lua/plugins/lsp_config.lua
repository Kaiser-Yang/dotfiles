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

    local max_code = 4
    local alphabet = 'abcdefghijklmnopqrstuvwxy'
    local mapped_punc = {
        [','] = '，',
        ['.'] = '。',
        [':'] = '：',
        ['?'] = '？',
        ['\\'] = '、'
        -- FIX: can not work now
        -- [';'] = '；',
    }

    local feedkeys = require('utils').feedkeys
    local function match_alphabet(txt)
        return string.match(txt, '^[' .. alphabet .. ']+$') ~= nil
    end

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

    -- Select first entry when typing more than max_code
    for i = 1, #alphabet do
        local k = alphabet:sub(i, i)
        map_set({ 'i' }, k, function()
            local cursor_column = vim.api.nvim_win_get_cursor(0)[2]
            local confirmed = false
            if vim.g.rime_enabled and cursor_column >= max_code and vim.bo.buftype ~= 'prompt' then
                local content_before_cursor = string.sub(vim.api.nvim_get_current_line(),
                    1, cursor_column)
                local code = string.sub(content_before_cursor,
                    cursor_column - max_code + 1, cursor_column)
                if match_alphabet(code) then
                    -- This is for wubi users using 'z' as reverse look up
                    if not string.match(content_before_cursor, 'z[' .. alphabet .. ']*$') then
                        local first_rime_item_index = require('plugins.rime_ls').get_n_rime_item_index(1)
                        if #first_rime_item_index ~= 1 then
                            -- clear the wrong code
                            for _ = 1, max_code do
                                feedkeys('<bs>', 'n')
                            end
                        else
                            require('blink.cmp').accept({ index = first_rime_item_index[1] })
                            confirmed = true
                        end
                    end
                end
            end
            if confirmed then
                vim.schedule(function() feedkeys(k, 'n') end)
            else
                feedkeys(k, 'n')
            end
        end)
    end
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
