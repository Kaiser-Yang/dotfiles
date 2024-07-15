---@diagnostic disable: assign-type-mismatch, missing-fields
local lspkind = require('lspkind')
local cmp = require'cmp'

cmp.setup {
    preselect = cmp.PreselectMode.None,

    snippet = {
        expand = function(args)
            -- For `luasnip` users.
            require('luasnip').lsp_expand(args.body)
            -- -- For `vsnip` users.
            -- vim.fn["vsnip#anonymous"](args.body)
            -- For `ultisnips` users.
            -- vim.fn["UltiSnips#Anon"](args.body)
            -- For `snippy` users.
            -- require'snippy'.expand_snippet(args.body)
        end,
    },

    sources = cmp.config.sources {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "luasnip" },
        { name = "path" },
        { name = "dictionary", keyword_length = 2, max_item_count = 5 },
        { name = 'nvim_lua' },
        { name = 'lazydev', group_index = 0 }, -- for nvim config
        { name = "cmp_yanky", max_item_count = 3 },
        {
            name = "spell",
            option = {
                keep_all_entries = false,
                enable_in_context = function()
                    return true
                end,
                preselect_correct_word = true,
            },
            max_item_count = 5
        },
        { name = "calc", max_item_count = 3 },
        { name = "git", max_item_count = 5 },
        { name = "rg", max_item_count = 5, keyword_length = 4 },
        -- { name = "emoji", max_item_count = 3 },
    },

    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if require("luasnip").expand_or_jumpable() then
                require("luasnip").expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if require("luasnip").jumpable(-1) then
                require("luasnip").jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-y>'] = cmp.config.disable,
        ['<C-Space>'] = cmp.mapping.disable,
        -- cmp.mapping.complete(): trigger completion

        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        -- cmp.mapping.confirm({
        --     select = false,
        --     behavior = cmp.ConfirmBehavior.Insert,
        -- }),

        -- whether or not to use number to select completion item
        -- These may be useful for input method
        -- ['1'] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.mapping.confirm({
        --             select = true,
        --             behavior = cmp.ConfirmBehavior.Replace,
        --         })
        --     else
        --         fallback()
        --     end
        -- end),
        -- ['2'] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_next_item()
        --     else
        --         fallback()
        --     end
        -- end, { "i", "s" }),
        -- ['3'] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_next_item()
        --         cmp.select_next_item()
        --     else
        --         fallback()
        --     end
        -- end, { "i", "s" }),
    },

    formatting = {
        format = lspkind.cmp_format {
            mode = 'symbol',
            maxwidth = 50,
            ellipsis_char = '...',
            symbol_map = {
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰜢",
                Variable = "󰀫",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "󰈇",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "󰙅",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "",
                Calc = "",
                Git = "",
                Search = "",
                Rime = "",
                Clipboard = "",
                Call = "",
                Copilot = "",
            },
            before = function(entry, vim_item)
                vim_item.menu = "["..string.upper(entry.source.name).."]"

                if entry.source.name == "calc" then
                    vim_item.kind = "Calc"
                end

                if entry.source.name == "git" then
                    vim_item.kind = "Git"
                end

                if entry.source.name == "rg" then
                    vim_item.kind = "Search"
                end

                if entry.source.name == "cmp_yanky" then
                    vim_item.kind = "Clipboard"
                end

                -- if entry.source.name == "copilot" then
                --     vim_item.kind = "Copilot"
                -- end

                -- if entry.source.name == "rime" then
                --     vim_item.kind = "Rime"
                -- end

                -- vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
                return vim_item
            end,
        },
    },

    sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.sort_text,
            cmp.config.compare.recently_used,
            require("cmp-under-comparator").under,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
        }
    },
}

-- Use buffer source for `/`.
cmp.setup.cmdline({'/', '?'}, {
    mapping = cmp.mapping.preset.cmdline({
        ['<c-n>'] = ({c = false}),
        ['<c-p>'] = ({c = false}),
    }),
    sources = {
        { name = 'buffer' },
    }
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline({
        ['<c-n>'] = ({c = false}),
        ['<c-p>'] = ({c = false}),
    }),
    sources = cmp.config.sources {
        { name = 'path' },
        {
            name = 'cmdline',
            option = {
                ignore_cmds = { 'Man', '!' }
            }
        },
    }
})
require("cmp_dictionary").setup({
    paths = { vim.fn.expand("~/.config/nvim/dict/en_dict.txt") },
    exact_length = 2,
    first_case_insensitive = true,
    document = {
        enable = true,
        command = { "wn", "${label}", "-over" },
    },
})

-- cmp.event:on("menu_opened", function()
--     vim.b.copilot_suggestion_hidden = true
-- end)
--
-- cmp.event:on("menu_closed", function()
--     vim.b.copilot_suggestion_hidden = false
-- end)

-- require("tailwindcss-colorizer-cmp").setup({
--     color_square_width = 2,
-- })
