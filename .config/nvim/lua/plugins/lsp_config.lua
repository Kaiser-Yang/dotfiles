local utils = require('utils')
return {
    'neovim/nvim-lspconfig',
    lazy = false,
    config = function()
        vim.lsp.config('*', {
            capabilities = require('utils').get_lsp_capabilities(),
            root_markers = vim.g.root_markers,
        })
        local names = {
            'bashls',
            'clangd',
            'eslint',
            'jsonls',
            'lemminx',
            'lua_ls',
            'neocmake',
            'pyright',
            'rime_ls',
            'tailwindcss',
            'ts_ls',
            'vue_ls',
            'yamlls',
            'markdown_oxide',
        }
        for _, nm in ipairs(names) do
            vim.lsp._enabled_configs[nm] = {}
        end

        --- @param bufnr integer
        --- @param config vim.lsp.Config
        local function start_config(bufnr, config)
            return vim.lsp.start(config, {
                bufnr = bufnr,
                reuse_client = config.reuse_client,
                _root_markers = config.root_markers,
            })
        end
        vim.api.nvim_create_autocmd('FileType', {
            group = 'UserDIY',
            callback = function(args)
                local bufnr = args.buf
                if utils.is_big_file(bufnr) then
                    vim.notify(
                        'LSP is disabled for this file due to its size.',
                        vim.log.levels.WARN
                    )
                    return
                end
                if vim.bo[bufnr].buftype ~= '' then return end
                for name in pairs(vim.lsp._enabled_configs) do
                    local config = vim.lsp.config[name]
                    if
                        config
                        and config.filetypes
                        and vim.tbl_contains(config.filetypes, vim.bo[bufnr].filetype)
                        and vim.lsp.is_enabled(name)
                    then
                        -- Deepcopy config so chagnes done in the client
                        -- do not propagate to the enabled config
                        config = vim.deepcopy(config)
                        if type(config.root_dir) == 'function' then
                            ---@param root_dir string
                            config.root_dir(bufnr, function(root_dir)
                                config.root_dir = root_dir
                                vim.schedule(function() start_config(bufnr, config) end)
                            end)
                        else
                            start_config(bufnr, config)
                        end
                    end
                end
            end,
        })
    end,
}
