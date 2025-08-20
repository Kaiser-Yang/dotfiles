local M = {}

function M.is_popup(winid)
    winid = winid or 0
    if winid == 0 then winid = vim.api.nvim_get_current_win() end
    local ok, config = pcall(vim.api.nvim_win_get_config, winid)
    if not ok then return false end
    return config.relative ~= ''
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
