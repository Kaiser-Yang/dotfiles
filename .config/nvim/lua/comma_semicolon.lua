local M = {}
local utils = require('utils')

local function can_repeat(fu) return type(fu) == 'function' end

-- We do not support 'o' mode now
utils.map_set_all({
    {
        { 'n', 'x' },
        ',',
        function()
            if can_repeat(vim.b.last_prev_function) then
                local res = vim.b.last_prev_function()
                if type(res) == 'string' then utils.feedkeys(res, 'n') end
            end
        end,
        { desc = 'Exteneded comma' },
    },
    {
        { 'n', 'x' },
        ';',
        function()
            if can_repeat(vim.b.last_next_function) then
                local res = vim.b.last_next_function()
                if type(res) == 'string' then utils.feedkeys(res, 'n') end
            end
        end,
        { desc = 'Extended semicolon' },
    },
})
local function case_sensitive_once()
    vim.o.ignorecase = false
    vim.o.smartcase = false
    vim.schedule(function()
        vim.o.ignorecase = true
        vim.o.smartcase = true
    end)
end
local find_till = { 'F', 'f', 'T', 't' }
-- builtin and can be repeated by comma and semicolon
local builtin_motions = { 'b', 'w', 'B', 'W', 'ge', 'e', 'gE', 'E' }
-- builtin but can not be repeated by comma or semicolon
local extra_builtin_motions = { 'N', 'n', '[s', ']s' }
vim.g.flash_keys = vim.g.flash_keys or {}
vim.g.last_motion_char = vim.g.last_motion_char or ''

local function update_find_or_till_char()
    local ok, char = pcall(vim.fn.getcharstr)
    if ok and #char == 1 then
        local byte = string.byte(char)
        if byte >= 32 and byte <= 126 then
            -- Only record printable character
            vim.g.last_motion_char = char
        end
    end
end

local function make_builtin_func(cmd)
    return function() vim.cmd('normal! ' .. vim.v.count1 .. cmd) end
end

--- @param key string
--- @param is_flash boolean
local function make_find_till_func(key, is_flash)
    return function()
        local mode = 'n'
        if is_flash then
            mode = 'm'
            case_sensitive_once()
        end
        utils.feedkeys(key .. vim.g.last_motion_char, mode .. 't')
    end
end

--- @param key string
--- @param is_flash boolean
local function find_till_func(key, is_flash)
    return function(_)
        update_find_or_till_char()
        make_find_till_func(key, is_flash)()
    end
end

--- @param func function
--- @param args table
--- @param use_v_count1 boolean
local function make_custom_func(func, args, use_v_count1)
    return function()
        local res = func(unpack(args))
        return (use_v_count1 and vim.v.count1 or '') .. (res or '')
    end
end
--- @param a any
--- @param b any
--- @param msg string
local function assert_pair_consistency(a, b, msg) assert((a and b) or not (a or b), msg) end

--- @param tbl table
--- @param v1 any
--- @param v2 any
local function is_pair(tbl, v1, v2) return vim.tbl_contains(tbl, v1), vim.tbl_contains(tbl, v2) end

--- @param prev_func function|string
--- @param next_func function|string
--- @param reversed boolean
--- @return function
local function repeat_wrapper(prev_func, next_func, reversed)
    local prev_is_builtin, next_is_builtin = is_pair(builtin_motions, prev_func, next_func)
    assert_pair_consistency(
        prev_is_builtin,
        next_is_builtin,
        'Both prev_func and next_func should be either built-in motions or custom functions.'
    )

    local prev_is_extra_builtin, next_is_extra_builtin =
        is_pair(extra_builtin_motions, prev_func, next_func)
    assert_pair_consistency(
        prev_is_extra_builtin,
        next_is_extra_builtin,
        'Both prev_func and next_func should be either extra built-in motions or custom functions.'
    )

    local prev_is_find_till, next_is_find_till = is_pair(find_till, prev_func, next_func)
    assert_pair_consistency(
        prev_is_find_till,
        next_is_find_till,
        'Both prev_func and next_func should be either find/till motions or custom functions.'
    )

    local prev_is_flash_find_till, next_is_flash_find_till =
        vim.g.flash_keys[prev_func], vim.g.flash_keys[next_func]
    assert_pair_consistency(
        prev_is_flash_find_till,
        next_is_flash_find_till,
        'Both prev_func and next_func should be either flash find/till motions or custom functions.'
    )

    local is_builtin = prev_is_builtin and next_is_builtin
    local is_extra_builtin = prev_is_extra_builtin and next_is_extra_builtin
    local is_find_till = prev_is_find_till and next_is_find_till
    local is_flash_find_till = prev_is_flash_find_till and next_is_flash_find_till and true
    assert(
        not (is_find_till and is_flash_find_till),
        'Cannot use both find/till and flash find/till at the same time.'
    )

    local prev_key = type(prev_func) == 'string' and prev_func or ''
    local next_key = type(next_func) == 'string' and next_func or ''
    if is_find_till or is_flash_find_till then
        prev_func = find_till_func(prev_key, is_flash_find_till)
        next_func = find_till_func(next_key, is_flash_find_till)
    end
    if type(prev_func) == 'string' then prev_func = utils.value_wrapper(prev_func) end
    if type(next_func) == 'string' then next_func = utils.value_wrapper(next_func) end
    return function(...)
        local args = { ... }
        if vim.tbl_contains({ 'v', 'V', 'CTRL-V', 'n' }, vim.fn.mode()) then
            if is_find_till or is_flash_find_till then
                assert(type(prev_key) == 'string' and type(next_key) == 'string')
                local _prev = reversed and next_key or prev_key
                local _next = reversed and prev_key or next_key
                vim.b.last_prev_function = make_find_till_func(_prev, is_flash_find_till)
                vim.b.last_next_function = make_find_till_func(_next, is_flash_find_till)
            elseif is_builtin then
                local _prev = reversed and ';' or ','
                local _next = reversed and ',' or ';'
                vim.b.last_prev_function = make_builtin_func(_prev)
                vim.b.last_next_function = make_builtin_func(_next)
            else
                local _prev = reversed and next_func or prev_func
                local _next = reversed and prev_func or next_func
                vim.b.last_prev_function = make_custom_func(_prev, args, is_extra_builtin)
                vim.b.last_next_function = make_custom_func(_next, args, is_extra_builtin)
            end
        end
        -- Do not use
        -- return reversed and prev_func(...) or next_func(...)
        -- Because prev_func(...) may return nil
        if reversed then
            return prev_func(...)
        else
            return next_func(...)
        end
    end
end

--- @param prev_func function|string
--- @param next_func function|string
--- @return function, function
function M.make(prev_func, next_func)
    return repeat_wrapper(prev_func, next_func, true), repeat_wrapper(prev_func, next_func, false)
end

return M
