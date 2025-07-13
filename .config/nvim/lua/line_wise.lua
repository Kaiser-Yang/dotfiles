-- This idea comes from: https://github.com/mluders/comfy-line-numbers.nvim
-- But I did a lot improvements and changes

-- only show combinations of '12345' as the line numbers
local desired_dignits = '12345'
-- max length of the line numbers, this makes `#desired_dignits ^ max_lenght` combinations
local max_lenght = 3
--- @class LineWiseKey
--- @field [1] string[]|string
--- @field [2] string
--- @field [3]? string
--- @type LineWiseKey[]
local line_wise_keys = {
    { { 'n', 'x', 'o' }, 'j' },
    { { 'n', 'x', 'o' }, 'k' },
    { { 'n' }, 'dd' },
    { { 'n' }, 'cc' },
    { { 'n' }, 'D' },
    { { 'n' }, 'C' },
    -- TODO:
    -- There may be some keys I forget to add
    { { 'n' }, '<space>c<space>', '<f30>' },
}

local labels = {}
local function generate_labels()
    local function generate_recursive(current, length)
        if length == 0 then
            table.insert(labels, current)
            labels[current] = #labels
            return
        end
        for i = 1, #desired_dignits do
            generate_recursive(current .. desired_dignits:sub(i, i), length - 1)
        end
    end
    for i = 1, max_lenght do
        generate_recursive('', i)
    end
end
generate_labels()
function _G.get_label()
    if vim.v.virtnum ~= 0 then
        -- do not show line numbers for wrap lines
        return ' '
    elseif vim.v.relnum == 0 then
        return string.format('%2d', vim.fn.line('.'))
    elseif vim.v.relnum > 0 and vim.v.relnum <= #labels then
        return string.format('%2s', labels[vim.v.relnum])
    else
        return string.format('%2d', vim.v.lnum)
    end
end
local function is_popup(winid)
    local ok, config = pcall(vim.api.nvim_win_get_config, winid)
    if not ok then return false end
    return config.relative ~= ''
end
vim.api.nvim_create_autocmd({ 'WinNew', 'BufWinEnter', 'BufEnter', 'TermOpen' }, {
    group = 'UserDIY',
    pattern = '*',
    callback = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if not is_popup(win) then
                vim.api.nvim_win_call(
                    win,
                    function() vim.opt.statuscolumn = '%=%s%=%{v:lua.get_label()} ' end
                )
            end
        end
    end,
})
local map_set = require('utils').map_set
local feedkeys = require('utils').feedkeys
for _, key_mapping in ipairs(line_wise_keys) do
    local modes, key, virtual_key = unpack(key_mapping)
    local target_key = virtual_key or key
    local feed_mode = virtual_key and 'm' or 'n'
    if type(modes) == 'string' then modes = { modes } end
    map_set(modes, key, function()
        local v_count = vim.v.count
        local actual_count = labels[tostring(v_count)] or v_count
        -- default to goes down, unless the key is 'k'
        local target_line = vim.fn.line('.') + (key == 'k' and -actual_count or actual_count)
        local first_visible_line = vim.fn.line('w0')
        local last_visible_line = vim.fn.line('w$')
        if target_line < first_visible_line or target_line > last_visible_line then
            actual_count = v_count
        end
        if actual_count ~= 0 then
            -- We +1 here to make other operations more reasonable
            if key ~= 'j' and key ~= 'k' then actual_count = actual_count + 1 end
            feedkeys(tostring(actual_count), 'n')
        end
        feedkeys(target_key, feed_mode)
    end, { desc = 'Line-wise navigation with comfy labels' })
end
