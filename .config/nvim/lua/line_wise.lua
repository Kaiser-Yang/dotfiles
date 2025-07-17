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
        return ''
    elseif vim.v.relnum == 0 then
        return ' 0'
    elseif vim.v.relnum > 0 and vim.v.relnum <= #labels then
        return string.format('%2s', labels[vim.v.relnum])
    else
        return string.format('%2s', vim.v.relnum)
    end
end
local function get_actual_count(key)
    local treesitter_context_visible_lines = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local cfg = vim.api.nvim_win_get_config(win)
        if
            cfg.relative == 'win'
            and cfg.row == 0
            and cfg.win == vim.api.nvim_get_current_win()
            and vim.w[win].treesitter_context_line_number
        then
            local lines = vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(win), 0, -1, false)
            vim.iter(lines):each(function(line)
                -- extract the number from the line
                local number = line:match('^[^%d]*(%d+)[^%d]*$')
                if not number then return end
                treesitter_context_visible_lines[tonumber(number)] = true
            end)
        end
    end
    local v_count = vim.v.count
    local actual_count = labels[tostring(v_count)] or v_count
    -- default to goes down, unless the key is 'k'
    local target_line = vim.fn.line('.') + (key == 'k' and -actual_count or actual_count)
    local first_visible_line = vim.fn.line('w0')
    local last_visible_line = vim.fn.line('w$')
    if
        (target_line < first_visible_line or target_line > last_visible_line)
        and not treesitter_context_visible_lines[v_count]
    then
        actual_count = v_count
    end
    return actual_count
end
local map_set = require('utils').map_set
local feedkeys = require('utils').feedkeys
for _, key_mapping in ipairs(line_wise_keys) do
    local modes, key, virtual_key = unpack(key_mapping)
    local target_key = virtual_key or key
    local feed_mode = virtual_key and 'm' or 'n'
    if type(modes) == 'string' then modes = { modes } end
    for _, mode in ipairs(modes) do
        if mode == 'o' then
            map_set(mode, key, function()
                local actual_count = get_actual_count(key)
                local prefix = ''
                if actual_count ~= 0 then
                    prefix = string.rep('<del>', #tostring(vim.v.count)) .. tostring(actual_count)
                end
                return prefix .. target_key
            end, { desc = 'Line-wise navigation with comfy labels', expr = true })
        else
            map_set(mode, key, function()
                local actual_count = get_actual_count(key)
                local prefix = ''
                if actual_count ~= 0 then
                    -- We +1 here to make other operations more reasonable
                    if key ~= 'j' and key ~= 'k' then actual_count = actual_count + 1 end
                    prefix = prefix .. tostring(actual_count)
                elseif (key == 'j' or key == 'k') and vim.bo.filetype ~= 'qf' then
                    prefix = 'g'
                end
                feedkeys(prefix .. target_key, feed_mode)
            end, { desc = 'Line-wise navigation with comfy labels' })
        end
    end
end
