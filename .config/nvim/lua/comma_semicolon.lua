local M = {}
local utils = require('utils')

local function can_repeat(fu) return type(fu) == 'function' end

utils.map_set_all({
    {
        { 'n', 'x' },
        ',',
        function()
            if can_repeat(vim.b.last_prev_function) then return vim.b.last_prev_function() end
            return ','
        end,
        { desc = 'Exteneded comma', expr = true },
    },
    {
        { 'n', 'x' },
        ';',
        function()
            if can_repeat(vim.b.last_next_function) then return vim.b.last_next_function() end
            return ';'
        end,
        { desc = 'Extended semicolon', expr = true },
    },
})

--- @param prev_func function
--- @param next_func function
--- @param reversed boolean
--- @return function
local function repeat_wrapper(prev_func, next_func, reversed)
    return function(...)
        vim.b.last_prev_function = reversed and next_func or prev_func
        vim.b.last_next_function = reversed and prev_func or next_func
        return reversed and prev_func(...) or next_func(...)
    end
end

--- @param prev_func function|string
--- @param next_func function|string
--- @return function, function
function M.make(prev_func, next_func)
    prev_func = type(prev_func) == 'string' and utils.value_wrapper(prev_func) or prev_func
    next_func = type(next_func) == 'string' and utils.value_wrapper(next_func) or next_func
    assert(
        type(prev_func) == 'function' and type(next_func) == 'function',
        'prev_func and next_func must be functions or strings'
    )
    return repeat_wrapper(prev_func, next_func, true), repeat_wrapper(prev_func, next_func, false)
end

return M
