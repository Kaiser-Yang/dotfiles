local utils = require('utils')
local completion_keymap = {
    preset = 'none',
    ['<c-x>'] = {
        function(cmp)
            if cmp.is_visible() then
                cmp.show_documentation()
            else
                cmp.show({ providers = { 'snippets' } })
            end
        end,
    },
    ['<cr>'] = { 'accept', 'fallback' },
    ['<tab>'] = { 'snippet_forward', 'fallback' },
    ['<s-tab>'] = { 'snippet_backward', 'fallback' },
    ['<c-u>'] = { 'scroll_documentation_up', 'fallback' },
    ['<c-d>'] = { 'scroll_documentation_down', 'fallback' },
    ['<c-j>'] = { 'select_next', 'fallback' },
    ['<c-k>'] = { 'select_prev', 'fallback' },
    ['<c-c>'] = { 'cancel', 'fallback' },
    ['<space>'] = {
        function(cmp)
            if not vim.g.rime_enabled then return false end
            local content_before_cursor =
                string.sub(vim.api.nvim_get_current_line(), 1, vim.api.nvim_win_get_cursor(0)[2])
            if content_before_cursor:match('%w+$') == nil then return false end
            local rime_item_index = utils.get_n_rime_item_index(1, nil)
            if #rime_item_index ~= 1 then return false end
            return cmp.accept({ index = rime_item_index[1] })
        end,
        'fallback',
    },
    [';'] = {
        -- FIX: can not work when binding ;<space> to other key
        function(cmp)
            if not vim.g.rime_enabled then return false end
            local content_before_cursor =
                string.sub(vim.api.nvim_get_current_line(), 1, vim.api.nvim_win_get_cursor(0)[2])
            if content_before_cursor:match('%w+$') == nil then return false end
            local rime_item_index = utils.get_n_rime_item_index(2, nil)
            if #rime_item_index ~= 2 then return false end
            return cmp.accept({ index = rime_item_index[2] })
        end,
        'fallback',
    },
    ['z'] = {
        function(cmp)
            if not vim.g.rime_enabled then return false end
            local content_before_cursor =
                string.sub(vim.api.nvim_get_current_line(), 1, vim.api.nvim_win_get_cursor(0)[2])
            if content_before_cursor:match('z%w*$') then return false end
            local rime_item_index = utils.get_n_rime_item_index(3, nil)
            if #rime_item_index ~= 3 then return false end
            return cmp.accept({ index = rime_item_index[3] })
        end,
        'fallback',
    },
}
local function pr_or_issue_configure_score_offset(items)
    -- Bonus to make sure items sorted as below:
    local keys = {
        -- place `kind_name` here
        { 'openIssue', 'openedIssue', 'reopenedIssue' },
        { 'openPR', 'openedPR' },
        { 'lockedIssue', 'lockedPR' },
        { 'completedIssue' },
        { 'draftPR' },
        { 'mergedPR' },
        { 'closedPR', 'closedIssue', 'not_plannedIssue', 'duplicateIssue' },
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
        if bonus_score[bonus_key] then items[i].score_offset = bonus_score[bonus_key] end
        -- sort by number when having the same bonus score
        local number = items[i].label:match('[#!](%d+)')
        if number then
            if items[i].score_offset == nil then items[i].score_offset = 0 end
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

return {
    {
        'saghen/blink.cmp',
        dependencies = {
            'mikavilpas/blink-ripgrep.nvim',
            'Kaiser-Yang/blink-cmp-dictionary',
            'Kaiser-Yang/blink-cmp-git',
            'Kaiser-Yang/blink-cmp-avante',
            'rafamadriz/friendly-snippets',
        },
        version = '*',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            fuzzy = {
                use_frecency = false,
            },
            completion = {
                keyword = {
                    range = 'full',
                },
                list = {
                    -- preselect = true is helpful for snippets
                    selection = { preselect = true, auto_insert = true },
                },
                menu = {
                    border = 'rounded',
                    max_height = 15,
                    scrolloff = 0,
                    draw = {
                        align_to = 'label',
                        padding = 0,
                        columns = {
                            { 'kind_icon' },
                            { 'label', 'label_description', gap = 1 },
                            { 'source_name' },
                        },
                        components = {
                            source_name = {
                                text = function(ctx) return '[' .. ctx.source_name .. ']' end,
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
                                    if code ~= '' then code = ' <' .. code .. '>' end
                                    return ctx.label .. code
                                end,
                            },
                        },
                    },
                },
                documentation = {
                    auto_show = false,
                    window = {
                        border = 'rounded',
                    },
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = 'rounded',
                    show_documentation = false,
                },
            },
            keymap = completion_keymap,
            cmdline = {
                keymap = completion_keymap,
                completion = {
                    menu = { auto_show = true },
                    ghost_text = { enabled = false },
                    list = { selection = { preselect = false, auto_insert = true } },
                },
            },
            sources = {
                default = function()
                    local result = {
                        'lsp',
                        'snippets',
                        'path',
                    }
                    if vim.bo.filetype == 'AvanteInput' then
                        result[#result + 1] = 'avante'
                    elseif
                        vim.tbl_contains({ 'gitcommit', 'markdown', 'octo' }, vim.bo.filetype)
                    then
                        result[#result + 1] = 'git'
                    end
                    if
                        vim.tbl_contains({ 'markdown', 'text', 'octo', 'Avante' }, vim.bo.filetype)
                        or utils.inside_block({ 'comment', 'string' })
                    then
                        vim.list_extend(result, {
                            'buffer',
                            'ripgrep',
                            'dictionary',
                        })
                    end
                    return result
                end,
                providers = {
                    avante = {
                        name = 'Avante',
                        module = 'blink-cmp-avante',
                    },
                    git = {
                        name = 'Git',
                        module = 'blink-cmp-git',
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
                            commit = { enable = false },
                            git_centers = {
                                github = {
                                    pull_request = {
                                        get_command_args = function(command, token)
                                            local args =
                                                require('blink-cmp-git.default.github').pull_request.get_command_args(
                                                    command,
                                                    token
                                                )
                                            args[#args] = args[#args] .. '?state=all'
                                            return args
                                        end,
                                        get_kind_name = function(item)
                                            return item.locked and 'lockedPR'
                                                or item.draft and 'draftPR'
                                                or item.merged_at and 'mergedPR'
                                                or item.state .. 'PR'
                                        end,
                                        configure_score_offset = pr_or_issue_configure_score_offset,
                                    },
                                    issue = {
                                        get_command_args = function(command, token)
                                            local args =
                                                require('blink-cmp-git.default.github').issue.get_command_args(
                                                    command,
                                                    token
                                                )
                                            args[#args] = args[#args] .. '?state=all'
                                            return args
                                        end,
                                        get_kind_name = function(item)
                                            return item.locked and 'lockedIssue'
                                                or (item.state_reason or item.state) .. 'Issue'
                                        end,
                                        configure_score_offset = pr_or_issue_configure_score_offset,
                                    },
                                },
                                gitlab = {
                                    pull_request = {
                                        get_command_args = function(command, token)
                                            local args =
                                                require('blink-cmp-git.default.gitlab').pull_request.get_command_args(
                                                    command,
                                                    token
                                                )
                                            args[#args] = args[#args] .. '?state=all'
                                            return args
                                        end,
                                        get_kind_name = function(item)
                                            return item.discussion_locked and 'lockedPR'
                                                or item.draft and 'draftPR'
                                                or item.state .. 'PR'
                                        end,
                                        configure_score_offset = pr_or_issue_configure_score_offset,
                                    },
                                    issue = {
                                        get_command_args = function(command, token)
                                            local args =
                                                require('blink-cmp-git.default.gitlab').issue.get_command_args(
                                                    command,
                                                    token
                                                )
                                            args[#args] = args[#args] .. '?state=all'
                                            return args
                                        end,
                                        get_kind_name = function(item)
                                            return item.discussion_locked and 'lockedIssue'
                                                or item.state .. 'Issue'
                                        end,
                                        configure_score_offset = pr_or_issue_configure_score_offset,
                                    },
                                },
                            },
                        },
                    },
                    dictionary = {
                        name = 'Dict',
                        module = 'blink-cmp-dictionary',
                        min_keyword_length = 3,
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
                            items = vim.tbl_filter(function(item)
                                -- Remove Snippets and Text from completion list
                                return item.kind ~= TYPE_ALIAS.Snippet
                                        and item.kind ~= TYPE_ALIAS.Text
                                        and not (vim.tbl_contains(
                                            { 'if', 'end', 'while', 'function', 'elseif' },
                                            item.label
                                        ) and item.kind == TYPE_ALIAS.Keyword)
                                    or utils.is_rime_item(item)
                                        and item.label:match('^%w*$') == nil
                            end, items)
                            if utils.rime_ls_disabled(context) then
                                return vim.tbl_filter(
                                    function(item) return not utils.is_rime_item(item) end,
                                    items
                                )
                            end
                            for _, item in ipairs(items) do
                                if utils.is_rime_item(item) then
                                    local idx = item.label:match('^(%d+)')
                                    if idx then
                                        -- make sure this is not affected by frecency
                                        item.score_offset = (#items - tonumber(idx)) * 9999
                                    end
                                end
                            end
                            return items
                        end,
                    },
                    snippets = { name = 'Snip' },
                    path = {
                        opts = {
                            trailing_slash = false,
                            show_hidden_files_by_default = true,
                        },
                    },
                    ripgrep = {
                        name = 'RG',
                        module = 'blink-ripgrep',
                        ---@module 'blink-ripgrep'
                        ---@type blink-ripgrep.Options
                        opts = {
                            prefix_min_len = 3,
                            context_size = 5,
                            max_filesize = '1M',
                            project_root_marker = vim.g.root_markers,
                            search_casing = '--smart-case',
                            project_root_fallback = false,
                            fallback_to_regex_highlighting = true,
                        },
                    },
                },
            },
        },
        opts_extend = { 'sources.default' },
    },
}
