local function pr_or_issue_configure_score_offset(items)
    -- Bonus to make sure items sorted as below:
    local keys = {
        -- place `kind_name` here
        { 'openIssue',     'openedIssue', 'reopenedIssue' },
        { 'openPR',        'openedPR' },
        { 'lockedIssue',   'lockedPR' },
        { 'completedIssue' },
        { 'draftPR' },
        { 'mergedPR' },
        { 'closedPR',      'closedIssue', 'not_plannedIssue', 'duplicateIssue' },
    }
    local bonus = 999999
    local bonus_score = {}
    for i = 1, #keys do
        for _, key in ipairs(keys[i]) do
            bonus_score[key] = bonus * (#keys - i)
        end
    end
    for i = 1, #items do
        local bonus_key = items[i].kind_name
        if bonus_score[bonus_key] then
            items[i].score_offset = bonus_score[bonus_key]
        end
        -- sort by number when having the same bonus score
        local number = items[i].label:match('[#!](%d+)')
        if number then
            if items[i].score_offset == nil then
                items[i].score_offset = 0
            end
            items[i].score_offset = items[i].score_offset + tonumber(number)
        end
    end
end

local blink_cmp_kind_name_highlight = {
    Dict = { default = false, fg = '#a6e3a1' },
}
for kind_name, hl in pairs(blink_cmp_kind_name_highlight) do
    vim.api.nvim_set_hl(0, 'BlinkCmpKind' .. kind_name, hl)
end

local blink_cmp_git_label_name_highlight = {
    Commit = { default = false, fg = '#a6e3a1' },
    openPR = { default = false, fg = '#a6e3a1' },
    openedPR = { default = false, fg = '#a6e3a1' },
    closedPR = { default = false, fg = '#f38ba8' },
    mergedPR = { default = false, fg = '#cba6f7' },
    draftPR = { default = false, fg = '#9399b2' },
    lockedPR = { default = false, fg = '#f5c2e7' },
    openIssue = { default = false, fg = '#a6e3a1' },
    openedIssue = { default = false, fg = '#a6e3a1' },
    reopenedIssue = { default = false, fg = '#a6e3a1' },
    completedIssue = { default = false, fg = '#cba6f7' },
    closedIssue = { default = false, fg = '#cba6f7' },
    not_plannedIssue = { default = false, fg = '#9399b2' },
    duplicateIssue = { default = false, fg = '#9399b2' },
    lockedIssue = { default = false, fg = '#f5c2e7' },
}
for kind_name, hl in pairs(blink_cmp_git_label_name_highlight) do
    vim.api.nvim_set_hl(0, 'BlinkCmpGitKindIcon' .. kind_name, hl)
    vim.api.nvim_set_hl(0, 'BlinkCmpGitLabel' .. kind_name .. 'Id', hl)
end

local function inside_comment_block()
    if vim.api.nvim_get_mode().mode ~= 'i' then
        return false
    end
    local node_under_cursor = vim.treesitter.get_node()
    local parser = vim.treesitter.get_parser(nil, nil, { error = false })
    local query = vim.treesitter.query.get(vim.bo.filetype, 'highlights')
    if not parser or not node_under_cursor or not query then
        return false
    end
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1
    for id, node, _ in query:iter_captures(node_under_cursor, 0, row, row + 1) do
        if query.captures[id] == 'comment' then
            local start_row, start_col, end_row, end_col = node:range()
            if start_row <= row and row <= end_row then
                if start_row == row and end_row == row then
                    if start_col <= col and col <= end_col then
                        return true
                    end
                elseif start_row == row then
                    if start_col <= col then
                        return true
                    end
                elseif end_row == row then
                    if col <= end_col then
                        return true
                    end
                else
                    return true
                end
            end
        end
    end
    return false
end

local function non_lsp_should_show_items()
    return vim.tbl_contains(vim.g.non_lsp_filetype, vim.bo.filetype) or inside_comment_block()
end

return {
    {
        'saghen/blink.cmp',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'mikavilpas/blink-ripgrep.nvim',
            'Kaiser-Yang/blink-cmp-dictionary',
            {
                'Kaiser-Yang/blink-cmp-git',
                dependencies = { 'nvim-lua/plenary.nvim' }
            },
            'Kaiser-Yang/blink-cmp-avante',
        },
        version = '*',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            fuzzy = {
                use_frecency = true,
            },
            completion = {
                keyword = {
                    range = 'full',
                },
                accept = {
                    auto_brackets = {
                        enabled = true,
                    },
                },
                list = {
                    selection = { preselect = false, auto_insert = true },
                },
                menu = {
                    border = 'rounded',
                    max_height = 15,
                    scrolloff = 0,
                    draw = {
                        align_to = 'cursor',
                        padding = 0,
                        columns = {
                            { 'kind_icon', },
                            { 'label',      'label_description', gap = 1 },
                            { 'source_name' }
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
                                    local code = ctx.label_detail:sub(code_start, code_end)
                                    code = string.gsub(code, '  ·  ', ' ')
                                    if code ~= '' then
                                        code = ' <' .. code .. '>'
                                    end
                                    return ctx.label .. code
                                end,
                            },
                        }
                    }
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                    update_delay_ms = 100,
                    treesitter_highlighting = true,
                    window = {
                        border = 'rounded',
                    },
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = 'rounded',
                }
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
                        local rime_item_index = require('plugins.rime_ls').get_n_rime_item_index(1)
                        if #rime_item_index ~= 1 then return false end
                        return cmp.accept({ index = rime_item_index[1] })
                    end,
                    'fallback' },
                [';'] = {
                    -- FIX: can not work when binding ;<space> to other key
                    function(cmp)
                        if not vim.g.rime_enabled then return false end
                        local rime_item_index = require('plugins.rime_ls').get_n_rime_item_index(2)
                        if #rime_item_index ~= 2 then return false end
                        return cmp.accept({ index = rime_item_index[2] })
                    end, 'fallback' },
                ['z'] = {
                    function(cmp)
                        if not vim.g.rime_enabled then return false end
                        local content_before_cursor = string.sub(vim.api.nvim_get_current_line(),
                            1, vim.api.nvim_win_get_cursor(0)[2])
                        if content_before_cursor:match('z%w*$') then return false end
                        local rime_item_index = require('plugins.rime_ls').get_n_rime_item_index(3)
                        if #rime_item_index ~= 3 then return false end
                        return cmp.accept({ index = rime_item_index[3] })
                    end, 'fallback' }
            },
            appearance = {
                nerd_font_variant = 'mono'
            },
            snippets = { preset = 'luasnip' },
            sources = {
                default = {
                    'lsp',
                    'path',
                    'snippets',
                    'buffer',
                    'ripgrep',
                    'lazydev',
                    'dictionary',
                    'git',
                    'markdown',
                    'avante',
                },
                providers = {
                    avante = {
                        module = 'blink-cmp-avante',
                        name = 'Avante',
                    },
                    markdown = {
                        name = 'Render',
                        module = 'render-markdown.integ.blink',
                        fallbacks = { 'lsp' }
                    },
                    git = {
                        -- Because we use filetype to enable the source,
                        -- we can make the score higher
                        score_offset = 100,
                        module = 'blink-cmp-git',
                        name = 'Git',
                        enabled = function()
                            return vim.tbl_contains({ 'gitcommit', 'markdown', 'octo' }, vim.bo.filetype)
                        end,
                        --- @module 'blink-cmp-git'
                        --- @type blink-cmp-git.Options
                        opts = {
                            kind_icons = {
                                openPR = '',
                                openedPR = '',
                                closedPR = '',
                                mergedPR = '',
                                draftPR = '',
                                lockedPR = '',
                                openIssue = '',
                                openedIssue = '',
                                reopenedIssue = '',
                                completedIssue = '',
                                closedIssue = '',
                                not_plannedIssue = '',
                                duplicateIssue = '',
                                lockedIssue = '',
                            },
                            git_centers = {
                                github = {
                                    pull_request = {
                                        get_command_args = function(command, token)
                                            local args = require('blink-cmp-git.default.github')
                                                .pull_request
                                                .get_command_args(command, token)
                                            args[#args] = args[#args] .. '?state=all'
                                            return args
                                        end,
                                        get_kind_name = function(item)
                                            return item.locked and 'lockedPR' or
                                                item.draft and 'draftPR' or
                                                item.merged_at and 'mergedPR' or
                                                item.state .. 'PR'
                                        end,
                                        configure_score_offset = pr_or_issue_configure_score_offset,
                                    },
                                    issue = {
                                        get_command_args = function(command, token)
                                            local args = require('blink-cmp-git.default.github')
                                                .issue
                                                .get_command_args(command, token)
                                            args[#args] = args[#args] .. '?state=all'
                                            return args
                                        end,
                                        get_kind_name = function(item)
                                            return item.locked and 'lockedIssue' or
                                                (item.state_reason or item.state) .. 'Issue'
                                        end,
                                        configure_score_offset = pr_or_issue_configure_score_offset,
                                    },
                                },
                                gitlab = {
                                    pull_request = {
                                        get_command_args = function(command, token)
                                            local args = require('blink-cmp-git.default.gitlab')
                                                .pull_request
                                                .get_command_args(command, token)
                                            args[#args] = args[#args] .. '?state=all'
                                            return args
                                        end,
                                        get_kind_name = function(item)
                                            return item.discussion_locked and 'lockedPR' or
                                                item.draft and 'draftPR' or
                                                item.state .. 'PR'
                                        end,
                                        configure_score_offset = pr_or_issue_configure_score_offset,
                                    },
                                    issue = {
                                        get_command_args = function(command, token)
                                            local args = require('blink-cmp-git.default.gitlab')
                                                .issue
                                                .get_command_args(command, token)
                                            args[#args] = args[#args] .. '?state=all'
                                            return args
                                        end,
                                        get_kind_name = function(item)
                                            return item.discussion_locked and 'lockedIssue' or
                                                item.state .. 'Issue'
                                        end,
                                        configure_score_offset = pr_or_issue_configure_score_offset,
                                    },
                                }
                            }
                        }
                    },
                    dictionary = {
                        module = 'blink-cmp-dictionary',
                        name = 'Dict',
                        min_keyword_length = 3,
                        max_items = 5,
                        should_show_items = non_lsp_should_show_items,
                        --- @module 'blink-cmp-dictionary'
                        --- @type blink-cmp-dictionary.Options
                        opts = {
                            dictionary_files = { vim.fn.expand('~/.config/nvim/dict/en_dict.txt') },
                        },
                    },
                    lsp = {
                        fallbacks = {},
                        --- @param context blink.cmp.Context
                        --- @param items blink.cmp.CompletionItem[]
                        transform_items = function(context, items)
                            local TYPE_ALIAS = require('blink.cmp.types').CompletionItemKind
                            local rime_ls = require('plugins.rime_ls')
                            -- demote snippets
                            for _, item in ipairs(items) do
                                if item.kind == TYPE_ALIAS.Snippet then
                                    item.score_offset = item.score_offset - 3
                                elseif rime_ls.is_rime_item(item) then
                                    local idx = item.label:match('^(%d+)')
                                    if idx then
                                        -- make sure this is not affected by frecency
                                        item.score_offset = (#items - tonumber(idx)) * 9999
                                    end
                                end
                            end
                            -- filter non-acceptable rime items
                            --- @param item blink.cmp.CompletionItem
                            return vim.tbl_filter(function(item)
                                if not rime_ls.is_rime_item(item) and
                                    item.kind ~= TYPE_ALIAS.Text then
                                    return true
                                end
                                if require('utils').rime_ls_disabled(context) then
                                    return false
                                end
                                item.detail = nil
                                return rime_ls.rime_item_acceptable(item)
                            end, items)
                        end
                    },
                    buffer = {
                        max_items = 5,
                        should_show_items = non_lsp_should_show_items,
                    },
                    snippets = { name = 'Snip' },
                    lazydev = {
                        name = 'LazyDev',
                        module = 'lazydev.integrations.blink',
                        score_offset = 100
                    },
                    ripgrep = {
                        module = 'blink-ripgrep',
                        name = 'RG',
                        max_items = 5,
                        should_show_items = non_lsp_should_show_items,
                        ---@module 'blink-ripgrep'
                        ---@type blink-ripgrep.Options
                        opts = {
                            prefix_min_len = 3,
                            context_size = 5,
                            max_filesize = '1M',
                            project_root_marker = vim.g.root_markers,
                            search_casing = '--smart-case',
                            project_root_fallback = false,
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
                    path = {
                        opts = {
                            trailing_slash = false,
                            show_hidden_files_by_default = true,
                        }

                    }
                }
            },
        },
        opts_extend = { 'sources.default' }
        -- TODO: add those below:
        -- { name = 'nvim_lua' },
        -- { name = "calc",   max_item_count = 3 },
        -- { name = "vimtex", },
        -- { name = "cmp_yanky", max_item_count = 3 },
    }
}
