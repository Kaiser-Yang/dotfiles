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
-- builtin and can be repeated by comma and semicolon
local builtin_motions = { 'b', 'w', 'B', 'W', 'ge', 'e', 'gE', 'E', 'F', 'f', 'T', 't' }
-- builtin but can not be repeated by comma or semicolon
local extra_builtin_motions = { 'N', 'n', '[s', ']s' }
vim.g.flash_keys = vim.g.flash_keys or {}
vim.g.last_motion_char = vim.g.last_motion_char or ''

--- @param prev_func function|string
--- @param next_func function|string
--- @param reversed boolean
--- @return function
local function repeat_wrapper(prev_func, next_func, reversed)
    local prev_is_builtin = vim.tbl_contains(builtin_motions, prev_func)
    local next_is_builtin = vim.tbl_contains(builtin_motions, next_func)
    assert(
        prev_is_builtin and next_is_builtin or not (prev_is_builtin or next_is_builtin),
        'Both prev_func and next_func should be either built-in motions or custom functions.'
    )
    local prev_is_extra_builtin = vim.tbl_contains(extra_builtin_motions, prev_func)
    local next_is_extra_builtin = vim.tbl_contains(extra_builtin_motions, next_func)
    assert(
        prev_is_extra_builtin and next_is_extra_builtin
            or not (prev_is_extra_builtin or next_is_extra_builtin),
        'Both prev_func and next_func should be either extra built-in motions or custom functions.'
    )
    local is_builtin = prev_is_builtin and next_is_builtin
    local is_extra_builtin = prev_is_extra_builtin and next_is_extra_builtin
    local is_find_or_till = vim.tbl_contains({ 'F', 'f', 'T', 't' }, prev_func)
        and vim.tbl_contains({ 'F', 'f', 'T', 't' }, next_func)
    local is_flash_find_or_till = vim.tbl_contains(vim.g.flash_keys, prev_func)
        and vim.tbl_contains(vim.g.flash_keys, next_func)
    local prev_key = prev_func
    local next_key = next_func
    if is_flash_find_or_till then
        assert(
            type(prev_key) == 'string' and type(next_key) == 'string',
            'prev_func and next_func should be string keys for flash find or till.'
        )
        prev_func = function(_)
            local ok, char = pcall(vim.fn.getcharstr)
            if ok and #char == 1 then
                local byte = string.byte(char)
                if byte >= 32 and byte <= 126 then
                    -- Only record printable character
                    vim.g.last_motion_char = char
                end
            end
            case_sensitive_once()
            char = char or ''
            utils.feedkeys(prev_key .. char, 'm')
        end
        next_func = function(_)
            local ok, char = pcall(vim.fn.getcharstr)
            if ok and #char == 1 then
                local byte = string.byte(char)
                if byte >= 32 and byte <= 126 then
                    -- Only record printable character
                    vim.g.last_motion_char = char
                end
            end
            case_sensitive_once()
            char = char or ''
            utils.feedkeys(next_key .. char, 'm')
        end
    end
    if type(prev_func) == 'string' then prev_func = utils.value_wrapper(prev_func) end
    if type(next_func) == 'string' then next_func = utils.value_wrapper(next_func) end
    return function(...)
        local args = { ... }
        if vim.tbl_contains({ 'v', 'V', 'CTRL-V', 'n' }, vim.fn.mode()) then
            if is_flash_find_or_till then
                assert(
                    type(prev_key) == 'string' and type(next_key) == 'string',
                    'prev_func and next_func should be string keys for flash find or till.'
                )
                vim.b.last_prev_function = reversed
                        and function()
                            case_sensitive_once()
                            utils.feedkeys(next_key .. vim.g.last_motion_char, 'm')
                        end
                    or function()
                        case_sensitive_once()
                        utils.feedkeys(prev_key .. vim.g.last_motion_char, 'm')
                    end
                vim.b.last_next_function = reversed
                        and function()
                            case_sensitive_once()
                            utils.feedkeys(prev_key .. vim.g.last_motion_char, 'm')
                        end
                    or function()
                        case_sensitive_once()
                        utils.feedkeys(next_key .. vim.g.last_motion_char, 'm')
                    end
            elseif is_find_or_till then
                vim.b.last_prev_function = function() vim.cmd('normal! ' .. vim.v.count1 .. ',') end
                vim.b.last_next_function = function() vim.cmd('normal! ' .. vim.v.count1 .. ';') end
            elseif is_builtin then
                vim.b.last_prev_function = reversed
                        and function() vim.cmd('normal! ' .. vim.v.count1 .. ';') end
                    or function() vim.cmd('normal! ' .. vim.v.count1 .. ',') end
                vim.b.last_next_function = reversed
                        and function() vim.cmd('normal! ' .. vim.v.count1 .. ',') end
                    or function() vim.cmd('normal! ' .. vim.v.count1 .. ';') end
            else
                local function get_prefix() return is_extra_builtin and vim.v.count1 or '' end
                vim.b.last_prev_function = reversed
                        and function()
                            local res = next_func(unpack(args))
                            return get_prefix() .. (res or '')
                        end
                    or function()
                        local res = prev_func(unpack(args))
                        return get_prefix() .. (res or '')
                    end
                vim.b.last_next_function = reversed
                        and function()
                            local res = prev_func(unpack(args))
                            return get_prefix() .. (res or '')
                        end
                    or function()
                        local res = next_func(unpack(args))
                        return get_prefix() .. (res or '')
                    end
            end
        end
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
