local M = {}
local utils = require('utils')

local function can_repeat(fu) return type(fu) == 'function' end

utils.map_set_all({
    {
        { 'n', 'v' },
        ',',
        function()
            if can_repeat(vim.b.last_prev_function) then return vim.b.last_prev_function() end
        end,
        { desc = 'Exteneded comma' },
    },
    {
        { 'n', 'v' },
        ';',
        function()
            if can_repeat(vim.b.last_next_function) then return vim.b.last_next_function() end
        end,
        { desc = 'Extended semicolon' },
    },
})

--- @param prev_func function
--- @param next_func function
--- @param reversed boolean
--- @return function
local function repeat_wrapper(prev_func, next_func, reversed)
    return function(...)
        if vim.tbl_contains({ 'v', 'V', 'CTRL-V', 'n' }, vim.fn.mode()) then
            vim.b.last_prev_function = reversed and next_func or prev_func
            vim.b.last_next_function = reversed and prev_func or next_func
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
    prev_func = type(prev_func) == 'string' and utils.value_wrapper(prev_func) or prev_func
    next_func = type(next_func) == 'string' and utils.value_wrapper(next_func) or next_func
    assert(
        type(prev_func) == 'function' and type(next_func) == 'function',
        'prev_func and next_func must be functions or strings'
    )
    return repeat_wrapper(prev_func, next_func, true), repeat_wrapper(prev_func, next_func, false)
end

return M
