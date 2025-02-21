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

    local max_code = 1000
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

    local map_set = require('utils').map_set
    local map_del = require('utils').map_del
    local utils = require('utils')
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
                map_set({ 'i' }, k .. '<space>', function()
                    if utils.rime_ls_disabled({ line = vim.api.nvim_get_current_line(),
                            cursor = vim.api.nvim_win_get_cursor(0) }) then
                        feedkeys(k .. '<space>', 'n')
                    else
                        feedkeys(v, 'n')
                    end
                end)
            end
        end
        vim.cmd('RimeToggle')
        if vim.api.nvim_get_mode().mode == 'i' then
            local content_before_cursor = string.sub(vim.api.nvim_get_current_line(),
                1, vim.api.nvim_win_get_cursor(0)[2])
            if content_before_cursor:match('[' .. alphabet .. ']+$') then
                require('blink.cmp').hide()
                require('blink.cmp').reload('lsp')
                vim.schedule(function()
                    require('blink.cmp').show()
                end)
            end
        end
    end)

    -- Select first entry when typing more than max_code
    for i = 1, #alphabet do
        local k = alphabet:sub(i, i)
        map_set({ 'i' }, k, function()
            local cursor_column = vim.api.nvim_win_get_cursor(0)[2]
            local confirmed = false
            if vim.g.rime_enabled and cursor_column >= max_code and vim.bo.buftype ~= 'prompt'
                and
                not utils.rime_ls_disabled({ line = vim.api.nvim_get_current_line(),
                    cursor = vim.api.nvim_win_get_cursor(0) }) then
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
        local vue_language_server_path =
            require('mason-registry').get_package('vue-language-server'):get_install_path() ..
            '/node_modules/@vue/language-server'

        local lspconfig = require('lspconfig')
        local lsp_default_options = {
            capabilities = lsp_capabilities,
        }
        local lsp_extra_options = {
            clangd = {},
            neocmake = {},
            pyright = {},
            jsonls = {},
            lemminx = {},
            yamlls = {},
            bashls = {},
            lua_ls = {
                handlers = {
                    ['$/progress'] = function(_, _, _) end,
                },
            },
            jdtls = {
                handlers = {
                    ['$/progress'] = function(_, _, _) end,
                },
            },
            rime_ls = {
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
            },
            volar = {},
            ts_ls = {
                init_options = {
                    plugins = {
                        {
                            name = '@vue/typescript-plugin',
                            location = vue_language_server_path,
                            languages = { 'vue' },
                        },
                    },
                },
                filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
            },
            eslint = {},
            tailwindcss = {},
        }
        for server, options in pairs(lsp_extra_options) do
            lspconfig[server].setup(vim.tbl_extend('force', lsp_default_options, options))
        end
    end,
}
