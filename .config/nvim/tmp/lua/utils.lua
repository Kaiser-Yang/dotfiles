local M = {}

function M.is_popup(winid)
    winid = winid or 0
    if winid == 0 then winid = vim.api.nvim_get_current_win() end
    local ok, config = pcall(vim.api.nvim_win_get_config, winid)
    if not ok then return false end
    return config.relative ~= ''
end

--- @param context { line: string, cursor: number[] }
--- Return if rime_ls should be disabled in current context
function M.rime_ls_disabled(context)
    if not vim.g.rime_enabled then return true end
    local line = context.line
    local cursor_column = context.cursor[2]
    for _, pattern in ipairs(vim.g.disable_rime_ls_pattern) do
        local start_pos = 1
        while true do
            local match_start, match_end = string.find(line, pattern, start_pos)
            if not match_start then break end
            if cursor_column >= match_start and cursor_column < match_end then return true end
            start_pos = match_end + 1
        end
    end
    return false
end

function M.is_rime_item(item)
    if item == nil or item.source_name ~= 'LSP' then return false end
    local client = vim.lsp.get_client_by_id(item.client_id)
    return client ~= nil and client.name == 'rime_ls'
end

--- @param n number
function M.get_n_rime_item_index(n, items)
    if items == nil then items = require('blink.cmp.completion.list').items end
    local result = {}
    if items == nil or #items == 0 then return result end
    for i, item in ipairs(items) do
        if M.is_rime_item(item) then
            result[#result + 1] = i
            if #result == n then break end
        end
    end
    return result
end

--- Return whether the buffer is empty
--- @param buf number|nil default 0 for current buffer
function M.is_empty_buffer(buf)
    buf = buf or 0
    return vim.api.nvim_buf_line_count(buf) and vim.api.nvim_buf_get_lines(buf, 0, 1, true)[1] == ''
end

function M.restore_cursor(schedule)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local func = function() vim.api.nvim_win_set_cursor(0, cursor_pos) end
    if schedule then
        vim.schedule(func)
    else
        func()
    end
end

return M
