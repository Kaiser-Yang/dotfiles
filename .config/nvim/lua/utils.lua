local M = {}

local map = vim.keymap

function M.get_visible_bufs()
    local visible_bufs = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if M.is_visible_buffer(buf) then visible_bufs[#visible_bufs + 1] = buf end
    end
    return visible_bufs
end

--- @param override? lsp.ClientCapabilities Overrides blink.cmp's default capabilities
--- @return lsp.ClientCapabilities
function M.get_lsp_capabilities(override)
    override = override or {}
    local default = {
        textDocument = {
            completion = {
                completionItem = {
                    -- Disable the snippets of lsp
                    snippetSupport = false,
                },
            },
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            },
        },
    }
    default = vim.tbl_deep_extend('force', default, override)
    return require('blink.cmp').get_lsp_capabilities(default)
end

function M.markdown_support_enabled()
    return vim.tbl_contains(vim.g.markdown_support_filetype, vim.bo.filetype)
end

function M.current_file_in_github_io()
    return vim.fn.expand('%:p'):find('Kaiser-Yang.github.io') ~= nil
end

M.wsl_init_done = false
function M.init_for_wsl()
    if vim.fn.has('wsl') ~= 1 or M.wsl_init_done then return end
    M.wsl_init_done = true
    local win_powershell_path = '/mnt/c/Windows/System32/WindowsPowerShell/v1.0/'
    if vim.fn.executable(win_powershell_path .. 'powershell.exe') == 1 then
        vim.env.PATH = win_powershell_path .. ':' .. vim.env.PATH
    end
end

--- @param types string[]
function M.inside_block(types)
    if vim.api.nvim_get_mode().mode ~= 'i' then return false end
    local node_under_cursor = vim.treesitter.get_node()
    local parser = vim.treesitter.get_parser(nil, nil, { error = false })
    if not parser or not node_under_cursor then return false end
    local query = vim.treesitter.query.get(parser:lang(), 'highlights')
    if not query then return false end
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1
    for id, node, _ in query:iter_captures(node_under_cursor, 0, row, row + 1) do
        for _, t in ipairs(types) do
            if query.captures[id]:find(t) then
                local start_row, start_col, end_row, end_col = node:range()
                if start_row <= row and row <= end_row then
                    if start_row == row and end_row == row then
                        if start_col <= col and col <= end_col then return true end
                    elseif start_row == row then
                        if start_col <= col then return true end
                    elseif end_row == row then
                        if col <= end_col then return true end
                    else
                        return true
                    end
                end
            end
        end
    end
    return false
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

--- @param item blink.cmp.CompletionItem
function M.is_rime_item(item)
    if item == nil or item.source_name ~= 'LSP' then return false end
    local client = vim.lsp.get_client_by_id(item.client_id)
    return client ~= nil and client.name == 'rime_ls'
end

--- @param n number
--- @param items? blink.cmp.CompletionItem[]
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

--- @param keys string
--- @param mode string
function M.feedkeys(keys, mode)
    local termcodes = vim.api.nvim_replace_termcodes(keys, true, true, true)
    vim.api.nvim_feedkeys(termcodes, mode, false)
end

--- @param callback function
--- @return function function():boolean always return true
function M.always_true_wrapper(callback)
    return function()
        callback()
        return true
    end
end

--- @return boolean
function M.has_root_directory()
    if vim.g.root_markers == nil then return false end
    return vim.fs.root(0, vim.g.root_markers) ~= nil
end

--- Return the root directory of current buffer by vim.g.root_markers
--- If the root directory is not found, return vim.fn.getcwd()
--- @return string
function M.get_root_directory()
    if vim.g.root_markers == nil then return vim.fn.getcwd() end
    return vim.fs.root(0, vim.g.root_markers) or vim.fn.getcwd()
end

--- Return whether the buffer is visible
--- @param buf number|nil default 0 for current buffer
function M.is_visible_buffer(buf)
    buf = buf or 0
    return vim.api.nvim_buf_is_valid(buf)
        and vim.api.nvim_get_option_value('buflisted', { buf = buf })
end

--- Return whether the buffer is empty
--- @param buf number|nil default 0 for current buffer
function M.is_empty_buffer(buf)
    buf = buf or 0
    return vim.api.nvim_buf_line_count(buf) and vim.api.nvim_buf_get_lines(buf, 0, 1, true)[1] == ''
end

--- Set a map with rhs
--- @param mode string|string[]
--- @param lhs string
--- @param rhs string|function
--- @param opts? table default: { silent = true, remap = false }
function M.map_set(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force', { silent = true, remap = false }, opts or {})
    map.set(mode, lhs, rhs, opts)
end

--- Delete a map by lhs
--- @param mode string|string[] the mode to delete
--- @param lhs string the key to delete
--- @param opts? { buffer: integer|boolean }
function M.map_del(mode, lhs, opts) map.del(mode, lhs, opts) end

return M
