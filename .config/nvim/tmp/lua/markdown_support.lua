-- Some markdown support for markdown files
-- Author: KaiserYang

local item_regex = {
    list = '^ *([*-] )',
    number_list = '^ *(%d+%. )',
    reference = '^ *(> )',
}
vim.g.auto_pairs_cr = vim.g.auto_pairs_cr or '<cr>'
vim.g.auto_pairs_bs = vim.g.auto_pairs_bs or '<bs>'
--- @param line string
local function match_item(line, must_end)
    for _, regex in pairs(item_regex) do
        local item = line:match(regex .. (must_end and '$' or ''))
        if item then return item end
    end
    return nil
end
local feedkeys = require('utils').feedkeys
--- Feed a list item by context
--- @param opts {cursor_line: number|nil}|nil
--- when cursor_line is nil, it will use the current cursor line number
--- @return boolean whether the list item is fed
local function feed_list_item_by_context(opts)
    local cursor_line = opts and opts.cursor_line or vim.api.nvim_win_get_cursor(0)[1]
    local item = nil
    local last_indent_pos = nil
    local context = nil
    while true do
        cursor_line = cursor_line - 1
        if cursor_line <= 0 then return false end
        context = vim.api.nvim_buf_get_lines(0, cursor_line - 1, cursor_line, true)[1]
        item = match_item(context)
        if item then
            item = string.gsub(item, 'x', ' ')
            feedkeys(item, 'n')
            return true
        elseif context:match('^ *$') then
            break
        end
        local match_result = context:match('^ *')
        if match_result == nil and last_indent_pos ~= nil and last_indent_pos ~= 0 then
            return false
        elseif
            match_result ~= nil
            and last_indent_pos ~= nil
            and last_indent_pos ~= #match_result
        then
            return false
        else
            last_indent_pos = match_result and #match_result or 0
        end
    end
    return false
end
local function finish_a_list()
    for _ = 1, vim.api.nvim_win_get_cursor(0)[2] do
        feedkeys('<bs>', 'n')
    end
    feedkeys('<cr>', 'n')
end
local function delete_a_list_item(item)
    for _ = 1, #item do
        feedkeys('<bs>', 'n')
    end
end
local function demote_a_list_item(item)
    delete_a_list_item(item)
    feedkeys('<tab>' .. item, 'n')
end
local function promote_a_list_item(item)
    delete_a_list_item(item)
    feedkeys('<bs>' .. item, 'n')
end
local function continue_a_list_item_next_line() feedkeys('<cr>', 'n') end
local function add_a_list_item_next_line(item)
    continue_a_list_item_next_line()
    feedkeys(item, 'n')
end
