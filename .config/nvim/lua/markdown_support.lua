-- Some markdown support for markdown files
-- Author: KaiserYang

local item_regex = {
    list = '^ *([*-] )',
    number_list = '^ *(%d+%. )',
    todo_list = '^ *([*-] %[[ x-]%] )',
    reference = '^ *(> )',
}
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
local function toggle_check_box_once(line_number)
    line_number = line_number or vim.api.nvim_win_get_cursor(0)[1]
    local item = nil
    local last_indent_pos = nil
    local context = nil
    while true do
        if line_number <= 0 then break end
        context = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, true)[1]
        item = context:match(item_regex.todo_list)
        if item then
            local new_line = context:match('^ *')
                .. string.gsub(
                    context,
                    item_regex.todo_list,
                    item:match('x') and '- [ ] ' or '- [x] '
                )
            vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, true, { new_line })
            return line_number - 1
        elseif context:match('^ *$') then
            break
        end
        local match_result = context:match('^ *')
        if match_result == nil and last_indent_pos ~= nil and last_indent_pos ~= 0 then
            break
        elseif
            match_result ~= nil
            and last_indent_pos ~= nil
            and last_indent_pos ~= #match_result
        then
            break
        else
            last_indent_pos = match_result and #match_result or 0
        end
        line_number = line_number - 1
    end
    return -1
end
local function toggle_check_box(start_line, end_line)
    start_line = start_line or vim.api.nvim_win_get_cursor(0)[1]
    end_line = end_line or start_line
    if start_line < end_line then
        start_line, end_line = end_line, start_line
    end
    while start_line >= end_line do
        start_line = toggle_check_box_once(start_line)
    end
end

vim.api.nvim_create_autocmd('FileType', {
    group = 'UserDIY',
    pattern = vim.g.markdown_support_filetype,
    callback = function()
        vim.cmd.setlocal('spell')
        local map_set = require('utils').map_set
        map_set({ 'i' }, ',f', function()
            local pattern = vim.fn.getreg('/')
            if pattern ~= '' then vim.schedule(function() vim.fn.setreg('/', pattern) end) end
            return "<c-g>u<c-o>mz<esc>/<++><cr>:nohlsearch<cr>c4l<cmd>call histdel('/', -1)<cr>"
        end, { buffer = true, silent = true, expr = true })
        map_set({ 'i' }, ',1', '<c-g>u<c-o>mz# ', { buffer = true })
        map_set({ 'i' }, ',2', '<c-g>u<c-o>mz## ', { buffer = true })
        map_set({ 'i' }, ',3', '<c-g>u<c-o>mz### ', { buffer = true })
        map_set({ 'i' }, ',4', '<c-g>u<c-o>mz#### ', { buffer = true })
        map_set({ 'i' }, ',a', '<c-g>u<c-o>mz[](<++>)<++><esc>F[a', { buffer = true })
        map_set({ 'i' }, ',b', '<c-g>u<c-o>mz****<++><esc>F*hi', { buffer = true })
        map_set({ 'i' }, ',c', '<c-g>u<c-o>mz```<cr>```<cr><++><esc>2kA', { buffer = true })
        map_set({ 'i' }, ',t', '<c-g>u<c-o>mz``<++><esc>F`i', { buffer = true })
        map_set({ 'i' }, ',u', '<esc>u`z:delmarks z<cr>a', { buffer = true })
        map_set({ 'n' }, 'o', 'A<cr>', { buffer = true, remap = true })
        map_set({ 'i' }, ',m', '<c-g>u<c-o>mz$$  $$<++><esc>F i', { buffer = true })
        -- map_set(
        --     { 'i' },
        --     ',p',
        --     '<c-g>u<c-o>mz<cr><cr>![](<++>){: .img-fluid}<cr><cr><++><esc>2k0f[a',
        --     { buffer = true }
        -- )
        -- map_set({ 'i' }, ',d', '<c-g>u<c-o>mz~~~~<++><esc>F~hi', { buffer = true })
        -- map_set({ 'i' }, ',i', '<c-g>u<c-o>mz**<++><esc>F*i', { buffer = true })
        -- map_set({ 'i' }, ',M', '<c-g>u<c-o>mz<cr><cr>$$<cr><cr>$$<cr><cr><++><esc>3kA', { buffer = true })
        -- TODO: make the gx in normal mode can be repeated
        map_set(
            { 'n' },
            'gx',
            toggle_check_box_once,
            { buffer = true, desc = 'Toggler current check box' }
        )
        map_set({ 'v' }, 'gx', function()
            local start_line = vim.fn.line('v')
            local end_line = vim.fn.line('.')
            toggle_check_box(start_line, end_line)
            feedkeys('<esc>', 'n')
        end, { buffer = true, desc = 'Toggler selected check boxes' })
        -- This part is to make <cr>, <bs> and <tab> work for bullets, numbers and todo lists
        map_set({ 'i' }, '<cr>', function()
            local cursor_column = vim.api.nvim_win_get_cursor(0)[2]
            local content_before_cursor = vim.api.nvim_get_current_line():sub(1, cursor_column)
            local item = match_item(content_before_cursor, true)
            if item then
                if content_before_cursor:sub(1, 1) ~= ' ' then
                    finish_a_list()
                else
                    promote_a_list_item(item)
                end
            else
                item = match_item(content_before_cursor)
                if item then
                    if #content_before_cursor == #vim.api.nvim_get_current_line() then
                        item = string.gsub(item, 'x', ' ')
                        add_a_list_item_next_line(item)
                    else
                        continue_a_list_item_next_line()
                    end
                elseif content_before_cursor:match('^ *$') and feed_list_item_by_context() then
                    -- pass
                else
                    feedkeys('<plug>(ultimate-auto-pairs-cr)', 'n')
                end
            end
        end, { buffer = true, expr = true })
        map_set({ 'i' }, '<bs>', function()
            local cursor_coloumn = vim.api.nvim_win_get_cursor(0)[2]
            local content_before_cursor = vim.api.nvim_get_current_line():sub(1, cursor_coloumn)
            local item = match_item(content_before_cursor, true)
            if item then
                delete_a_list_item(item)
            elseif content_before_cursor:match('^ +$') then
                feedkeys('<bs>', 'n')
                feed_list_item_by_context()
            else
                -- normal <bs>
                feedkeys('<plug>(ultimate-auto-pairs-bs)', 'n')
            end
        end, { buffer = true, expr = true })
        map_set({ 'i' }, '<tab>', function()
            local cursor_coloumn = vim.api.nvim_win_get_cursor(0)[2]
            local content_before_cursor = vim.api.nvim_get_current_line():sub(1, cursor_coloumn)
            local item = match_item(content_before_cursor, true)
            if item then
                demote_a_list_item(item)
            elseif content_before_cursor:match('^ *$') and feed_list_item_by_context() then
                -- pass
            else
                -- normal <tab>
                feedkeys('<tab>', 'n')
            end
        end, { buffer = true })
    end,
})
