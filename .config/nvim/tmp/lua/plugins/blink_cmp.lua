local utils = require('utils')
local enable_rime_quick_select = function()
    if not vim.g.rime_enabled then return false end
    local content_before_cursor =
        string.sub(vim.api.nvim_get_current_line(), 1, vim.api.nvim_win_get_cursor(0)[2])
    if
        not content_before_cursor:match('%w+$')
        or content_before_cursor:match('[^z]{4}$') -- wubi has a maximum of 4 characters
        or content_before_cursor:match('z%w{4}$') -- reverse query can have a leading 'z'
    then
        return false
    end
    return true
end
local function rime_select_item_wrapper(index)
    return function(cmp)
        if not enable_rime_quick_select() then return false end
        local rime_item_index = utils.get_n_rime_item_index(index)
        if #rime_item_index ~= index then return false end
        return cmp.accept({ index = rime_item_index[index] })
    end
end
local completion_keymap = {
    ['<space>'] = {
        rime_select_item_wrapper(1),
        'fallback',
    },
    -- FIX: can not work when binding ;<space> to other key
    [';'] = {
        rime_select_item_wrapper(2),
        'fallback',
    },
    ['z'] = {
        rime_select_item_wrapper(3),
        'fallback',
    },
}
return {
    {
        opts = {
            completion = {
                menu = {
                    draw = {
                        components = {
                            label = {
                                text = function(ctx)
                                    local client = vim.lsp.get_client_by_id(ctx.item.client_id)
                                    if
                                        not vim.g.rime_enabled
                                        or not client
                                        or client.name ~= 'rime_ls'
                                    then
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
            },
            sources = {
                providers = {
                    lsp = {
                        transform_items = function(context, items)
                            local TYPE_ALIAS = require('blink.cmp.types').CompletionItemKind
                            items = vim.tbl_filter(function(item)
                                -- Remove Snippets and Text from completion list
                                return item.kind ~= TYPE_ALIAS.Snippet
                                        and item.kind ~= TYPE_ALIAS.Text
                                        and not (item.kind == TYPE_ALIAS.Keyword and vim.g.filetype_ignored_keyword[vim.bo.filetype] and vim.tbl_contains(
                                            vim.g.filetype_ignored_keyword[vim.bo.filetype],
                                            item.label
                                        ))
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
                },
            },
        },
    },
}
