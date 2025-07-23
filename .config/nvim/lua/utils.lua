local M = {}

local map = vim.keymap

function M.get_fold_start(fold_start)
    local cur_fold_end = vim.fn.foldclosedend(fold_start)
    if cur_fold_end == -1 then
        vim.cmd(fold_start .. 'foldclose')
        cur_fold_end = vim.fn.foldclosedend(fold_start)
        vim.cmd(fold_start .. 'foldopen')
    else
        vim.cmd(fold_start .. 'foldopen')
    end
    local last_fold_end
    local res = { fold_start }
    -- Do not fold recursively when more than 1000 lines
    if cur_fold_end - fold_start > 1000 then return res end
    for line = fold_start + 1, cur_fold_end - 1 do
        local fold_lvl = vim.fn.foldlevel(line)
        if fold_lvl <= 0 then goto continue end
        local closed = vim.fn.foldclosed(line) == line
        if closed then vim.cmd(line .. 'foldopen') end
        if
            fold_lvl > vim.fn.foldlevel(line - 1)
            or fold_lvl == vim.fn.foldlevel(line - 1) and last_fold_end and line > last_fold_end
        then
            table.insert(res, line)
        end
        vim.cmd(line .. 'foldclose')
        last_fold_end = vim.fn.foldclosedend(line)
        vim.cmd(line .. 'foldopen')
        ::continue::
    end
    return res
end

function M.is_big_file(buf)
    buf = buf or 0
    local line_count = vim.api.nvim_buf_line_count(buf)
    local fs_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(buf))
    return fs_size > vim.g.big_file_limit or fs_size / line_count > vim.g.big_file_limit_per_line
end

function M.is_popup(winid)
    winid = winid or 0
    if winid == 0 then winid = vim.api.nvim_get_current_win() end
    local ok, config = pcall(vim.api.nvim_win_get_config, winid)
    if not ok then return false end
    return config.relative ~= ''
end

function M.input_action(prompt, callback)
    return function()
        local input = vim.fn.input(prompt)
        if not input or input:match('^%s*$') then
            return -- do nothing if input is empty
        end
        callback(input)
    end
end

function M.big_file_checker_wrapper(callback)
    return function()
        if M.is_big_file() then
            vim.notify('File is too big to search, operation aborted', vim.log.levels.WARN)
            return
        end
        callback()
    end
end

local get_actual_count = require('line_wise').get_actual_count
function M.line_wise_key_wrapper(key, operator_mode, feedkeys_mode)
    if operator_mode then
        return function()
            local actual_count = get_actual_count(key == 'k')
            if actual_count == 0 then return key end
            return string.rep('<del>', #tostring(vim.v.count)) .. tostring(actual_count) .. key
        end
    end
    return function()
        local actual_count = get_actual_count(key == 'k')
        local prefix = ''
        if actual_count == 0 then
            if (key == 'j' or key == 'k') and vim.bo.filetype ~= 'qf' then prefix = 'g' end
        else
            -- We +1 here to make other operations more reasonable
            if key ~= 'j' and key ~= 'k' then actual_count = actual_count + 1 end
            prefix = prefix .. tostring(actual_count)
        end
        M.feedkeys(prefix .. key, feedkeys_mode or 'n')
    end
end

function M.is_file(path)
    path = path and path or ''
    local fs_stat = vim.uv.fs_stat(path)
    return fs_stat and fs_stat.type == 'file'
end

function M.get_win_with_filetype(filetype)
    local res = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].filetype:match(filetype) then
            table.insert(res, win)
        end
    end
    return res
end
--- @param ft_list string|string[]
function M.disable_in_ft(ft_list)
    ft_list = type(ft_list) == 'string' and { ft_list } or ft_list
    return function(str)
        assert(type(ft_list) == 'table', 'Expected a table, got: ' .. type(ft_list))
        for _, f in ipairs(ft_list) do
            if vim.bo.filetype:match(f) then return '' end
        end
        return str
    end
end
function M.is_git_repo()
    if not vim.fn.executable('git') == 0 then return false end
    local out = vim.system({ 'git', 'rev-parse', '--is-inside-work-tree' }, {
        text = true,
    }):wait(50)
    return out.code == 0
end

function M.get_repo_remote_url(remote_name)
    remote_name = remote_name or 'origin'
    if vim.fn.executable('git') == 0 then return '' end
    local out = vim.system({ 'git', 'remote', 'get-url', remote_name }, {
        text = true,
        cwd = vim.fn.getcwd(),
    })
        :wait(50).stdout
    return out and out:gsub('\n', '') or ''
end

--- @return function
function M.value_wrapper(value)
    return function() return value end
end

function M.should_ignore_hidden_files() return not vim.fn.getcwd():match('dotfiles') end

function M.should_enable_paste_image()
    local plus_reg_content = vim.fn.getreg('+'):gsub('\r', '')
    local ok, _ = pcall(require, 'img-clip')
    return vim.bo.filetype ~= 'gitcommit'
        and M.markdown_support_enabled()
        and ok
        -- wsl will not put images in + reg
        and (vim.fn.has('wsl') == 0 or #plus_reg_content == 0)
end

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
    local ok, blink_cmp = pcall(require, 'blink.cmp')
    if not ok then return default end
    return blink_cmp.get_lsp_capabilities(default)
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
    if buf == 0 then buf = vim.api.nvim_get_current_buf() end
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
--- @param opts? vim.keymap.set.Opts default: { silent = true, remap = false }
function M.map_set(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force', { silent = true, remap = false }, opts or {})
    map.set(mode, lhs, rhs, opts)
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
function M.cursor_in_match()
    local pattern = vim.fn.getreg('/') -- Get last search pattern
    if pattern == '' then return end -- Skip if no pattern
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local match_pos =
        vim.fn.matchbufline(vim.api.nvim_get_current_buf(), pattern, cursor_pos[1], cursor_pos[1])
    for _, match in pairs(match_pos) do
        if match.byteidx <= cursor_pos[2] and match.byteidx + #match.text > cursor_pos[2] then
            return true
        end
    end
    return false
end

--- @class KeyMapping
--- @field [1] string|string[] the mode to map
--- @field [2] string the key to map
--- @field [3] string|function the rhs of the map
--- @field [4]? vim.keymap.set.Opts default: { silent = true, remap = false }

--- @param key_mappings KeyMapping[]
function M.map_set_all(key_mappings)
    for _, mapping in ipairs(key_mappings) do
        M.map_set(unpack(mapping))
    end
end

--- Delete a map by lhs
--- @param mode string|string[] the mode to delete
--- @param lhs string the key to delete
--- @param opts? { buffer: integer|boolean }
function M.map_del(mode, lhs, opts) map.del(mode, lhs, opts) end

vim.api.nvim_create_autocmd('User', {
    pattern = 'NetworkCheckedOK',
    callback = function() M.set_network_status(true) end,
})
local network_available_cache
function M.network_available() return network_available_cache end
function M.set_network_status(status) network_available_cache = status end
function M.start_to_check_network(force)
    if not force and network_available_cache ~= nil then return end
    local sock = vim.uv.new_tcp()
    if not sock then return end
    local domain = '114.114.114.114'
    sock:connect(domain, 53, function(err)
        if sock then sock:close() end
        if err then
            M.set_network_status(false)
            return
        end
        vim.schedule(
            function() vim.api.nvim_exec_autocmds('User', { pattern = 'NetworkCheckedOK' }) end
        )
    end)
end
return M
