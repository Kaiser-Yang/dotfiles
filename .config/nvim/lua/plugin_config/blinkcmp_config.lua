return {
    {
        'saghen/blink.cmp',
        dependencies = {
            {
                'L3MON4D3/LuaSnip',
                version = "v2.*",
                build = 'make install_jsregexp',
                dependencies = {
                    'rafamadriz/friendly-snippets',
                },
                config = function() require 'plugin_config/luasnip_config' end,
            },
            "mikavilpas/blink-ripgrep.nvim",
        },
        version = '*',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            completion = {
                list = {
                    selection = 'auto_insert',
                    max_items = 20,
                },
                menu = {
                    border = 'rounded',
                    max_height = 15,
                    scrolloff = 0,
                    draw = {
                        padding = 0,
                        columns = {
                            { "label",     "label_description", gap = 1 },
                            { "kind_icon", "source_name",       gap = 1 }
                        },
                        components = {
                            source_name = {
                                text = function(ctx) return '[' .. ctx.source_name .. ']' end
                            },
                            label = {
                                text = function(ctx)
                                    if not vim.g.rime_enabled then
                                        return ctx.label .. ctx.label_detail
                                    end
                                    local client = vim.lsp.get_client_by_id(ctx.item.client_id)
                                    if not client or client.name ~= 'rime_ls' then
                                        return ctx.label .. ctx.label_detail
                                    end
                                    local code_start = #ctx.label_detail + 1
                                    for i = 1, #ctx.label_detail do
                                        local ch = string.sub(ctx.label_detail, i, i)
                                        if ch >= 'a' and ch <= 'z' then
                                            code_start = i
                                            break
                                        end
                                    end
                                    local code_end = #ctx.label_detail - 4
                                    return ctx.label ..
                                        ' <' ..
                                        string.gsub(string.sub(ctx.label_detail, code_start, code_end), '  ·  ', ' ') ..
                                        '>'
                                end
                            },
                        }
                    }
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                    window = {
                        border = 'rounded'
                    }
                },
            },
            signature = {
                enabled = true,
                window = { border = 'rounded' }
            },
            keymap = {
                preset = 'none',
                ['<cr>'] = { 'accept', 'fallback' },
                ['<tab>'] = { 'snippet_forward', 'fallback' },
                ['<s-tab>'] = { 'snippet_backward', 'fallback' },
                ['<c-u>'] = { 'scroll_documentation_up', 'fallback' },
                ['<c-d>'] = { 'scroll_documentation_down', 'fallback' },
                ['<c-j>'] = { 'select_next', 'fallback' },
                ['<c-k>'] = { 'select_prev', 'fallback' },
                ['<c-x>'] = { 'show', 'fallback' },
                ['<c-c>'] = { 'cancel', 'fallback' },
                ['<space>'] = {
                    function(cmp)
                        if not vim.g.rime_enabled then return false end
                        local rime_item_index = get_n_rime_item_index(1)
                        if #rime_item_index ~= 1 then return false end
                        return cmp.accept({ index = rime_item_index[1] })
                    end,
                    'fallback' },
                [';'] = {
                    -- FIX: can not work when binding ;<space> to other key
                    function(cmp)
                        if not vim.g.rime_enabled then return false end
                        local rime_item_index = get_n_rime_item_index(2)
                        if #rime_item_index ~= 2 then return false end
                        return cmp.accept({ index = rime_item_index[2] })
                    end, 'fallback' },
                ['\''] = {
                    function(cmp)
                        if not vim.g.rime_enabled then return false end
                        local rime_item_index = get_n_rime_item_index(3)
                        if #rime_item_index ~= 3 then return false end
                        return cmp.accept({ index = rime_item_index[3] })
                    end, 'fallback' }
            },
            appearance = {
                nerd_font_variant = 'mono'
            },
            snippets = {
                expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
                active = function(filter)
                    if filter and filter.direction then
                        return require('luasnip').jumpable(filter.direction)
                    end
                    return require('luasnip').in_snippet()
                end,
                jump = function(direction) require('luasnip').jump(direction) end,
            },
            sources = {
                default = { 'lsp', 'path', 'luasnip', 'buffer', 'ripgrep', 'lazydev' },
                providers = {
                    lsp = {
                        fallbacks = nil,
                        --- @param items blink.cmp.CompletionItem[]
                        transform_items = function(_, items)
                            -- demote snippets
                            for _, item in ipairs(items) do
                                if item.kind == require('blink.cmp.types').CompletionItemKind.Snippet then
                                    item.score_offset = item.score_offset - 3
                                end
                            end
                            -- filter non-acceptable rime items
                            return vim.tbl_filter(function(item)
                                return not is_rime_item(item) or rime_item_acceptable(item)
                            end, items)
                        end
                    },
                    buffer = { max_items = 5 },
                    lazydev = {
                        name = 'LazyDev',
                        module = 'lazydev.integrations.blink',
                        score_offset = 100
                    },
                    ripgrep = {
                        module = "blink-ripgrep",
                        name = "Ripgrep",
                        max_items = 5,
                        ---@module "blink-ripgrep"
                        ---@type blink-ripgrep.Options
                        opts = {
                            prefix_min_len = 4,
                            context_size = 5,
                            max_filesize = "1M",
                            project_root_marker = { '.root', '.git' },
                            search_casing = "--smart-case",
                            -- (advanced) Any additional options you want to give to ripgrep.
                            -- See `rg -h` for a list of all available options. Might be
                            -- helpful in adjusting performance in specific situations.
                            -- If you have an idea for a default, please open an issue!
                            --
                            -- Not everything will work (obviously).
                            additional_rg_options = {},
                            -- When a result is found for a file whose filetype does not have a
                            -- treesitter parser installed, fall back to regex based highlighting
                            -- that is bundled in Neovim.
                            fallback_to_regex_highlighting = true,
                        },
                    },
                }
            },
        },
        opts_extend = { "sources.default" }
        -- TODO: add those below:

        -- { name = "dictionary", keyword_length = 2, max_item_count = 5 },
        -- { name = 'nvim_lua' },
        -- {
        --     name = "spell",
        --     option = {
        --         keep_all_entries = false,
        --         enable_in_context = function()
        --             return true
        --         end,
        --         preselect_correct_word = true,
        --     },
        --     max_item_count = 5
        -- },
        -- { name = "calc",   max_item_count = 3 },
        -- { name = "git",    max_item_count = 5 },
        -- { name = "vimtex", },
        -- { name = "cmp_yanky", max_item_count = 3 },
        -- { name = "emoji", max_item_count = 3 },
    }
}
