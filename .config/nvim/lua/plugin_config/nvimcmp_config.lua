local lspkind = require('lspkind')
local cmp = require'cmp'

cmp.setup {
    preselect = cmp.PreselectMode.None,
    -- completion = {
    --     completeopt = 'menu,menuone,noinsert,noselect'
    --     -- completeopt = 'menu,menuone'
    -- },
    -- experimental = { ghost_text = true },

    snippet = {
        expand = function(args)
            -- -- For `vsnip` users.
            -- vim.fn["vsnip#anonymous"](args.body)
            -- For `luasnip` users.
            require('luasnip').lsp_expand(args.body)
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
        { name = "dictionary", keyword_length = 2 },
        { name = 'nvim_lua' }
        -- {name = "nvim_lsp_signature_help", max_item_count = 1},
        -- {name = "nvim_lsp", max_item_count = 10},
        -- {name = "buffer", max_item_count = 8, keyword_length = 2},
        -- {name = "rg", max_item_count = 5, keyword_length = 4},
        -- {name = "git", max_item_count = 5, keyword_length = 2},
        -- {
        --     name = 'rime',
        --     option = {
        --     },
        -- },
        -- {
        --     name = 'rime_punct',
        --     option = {
        --     },
        -- },
        -- {name = "luasnip", max_item_count = 8},
        -- {name = "path"},
        -- {name = "codeium"}, -- INFO: uncomment this for AI completion
        -- {name = "spell", max_item_count = 4},
		-- {name = "cmp_yanky", max_item_count = 2},
        -- {name = "calc", max_item_count = 3},
        -- {name = "cmdline"},
        -- {name = "git"},
        -- {name = "emoji", max_item_count = 3},
        -- {name = "copilot"}, -- INFO: uncomment this for AI completion
        -- {name = "cmp_tabnine"}, -- INFO: uncomment this for AI completion
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
        -- ['<c-j>'] = cmp.mapping({
        --     c = cmp.mapping.select_next_item(),
        -- }),
        -- ['<c-k>'] = cmp.mapping({
        --     c = cmp.mapping.select_prev_item(),
        -- }),
        -- ['<C-c>'] = cmp.mapping({
        --     c = cmp.mapping.close(),
        -- }),
        -- trigger completion
        -- ['<C-j>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        -- ['<Space>'] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.mapping.confirm({
        --             select = true,
        --             behavior = cmp.ConfirmBehavior.Replace,
        --         })
        --     else
        --         fallback()
        --     end
        -- end, { 'i', 's' }),

        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.

        -- ['<Space>'] = cmp.mapping.confirm({
        --     select = false,
        --     behavior = cmp.ConfirmBehavior.Insert,
        -- }),
        -- ['<C-Space>'] = cmp.mapping.disable,
        -- ['<CR>'] = cmp.mapping({
        --     i = cmp.mapping.abort(),
        --     c = cmp.mapping.close(),
        -- }),

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
        -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
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

                if entry.source.name == "rime" then
                    vim_item.kind = "Rime"
                end

                -- if entry.source.name == "cmp_yanky" then
                --     vim_item.kind = "Clipboard"
                -- end

                -- if entry.source.name == "nvim_lsp_signature_help" then
                --     vim_item.kind = "Call"
                -- end

                -- vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
                return vim_item
            end,
        },
    },

    -- sorting = {
    --     comparators = {
    --         cmp.config.compare.offset,
    --         cmp.config.compare.exact,
    --         cmp.config.compare.score,
    --         cmp.config.compare.recently_used,
    --         require("cmp-under-comparator").under,
    --         -- require("cmp_tabnine.compare"), -- INFO: uncomment this for AI completion
    --         cmp.config.compare.kind,
    --         cmp.config.compare.sort_text,
    --         cmp.config.compare.length,
    --         cmp.config.compare.order,
    --     }
    -- },
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
-- require("cmp_dictionary").setup({
--     paths = { "/usr/share/dict/words" },
--     exact_length = 2,
--     first_case_insensitive = true,
--     document = {
--         enable = true,
--         command = { "wn", "${label}", "-over" },
--     },
-- })
-- vim.opt.spell = true
-- vim.opt.spelllang = { 'en_us' }

-- require("tailwindcss-colorizer-cmp").setup({
--     color_square_width = 2,
-- })
