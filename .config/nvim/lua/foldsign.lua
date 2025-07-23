local group = 'foldsign'
local utils = require('utils')
local M = {}

--- @class FoldSignCache
--- @field fold string? The name of the fold sign
--- @field sign_id number? The ID of the sign placed in the buffer
local fold_sign_cache = {}

local function update_range(buf, first, last)
    if not utils.is_visible_buffer(buf) then
        fold_sign_cache[buf] = nil
        return
    end
    if not fold_sign_cache[buf] then fold_sign_cache[buf] = {} end
    local cache = fold_sign_cache[buf]
    local last_fold_end
    for lnum = first, last do
        local fold_lvl = vim.fn.foldlevel(lnum)
        local sign_name = nil
        -- Calculate the new fold status and sign name
        if fold_lvl > 0 then
            local closed = vim.fn.foldclosed(lnum) == lnum
            if closed then
                sign_name = 'FoldClosed'
            elseif
                vim.fn.foldclosed(lnum) == -1
                and (
                    fold_lvl > vim.fn.foldlevel(lnum - 1)
                    or fold_lvl == vim.fn.foldlevel(lnum - 1)
                        and last_fold_end
                        and lnum > last_fold_end
                )
            then
                sign_name = 'FoldOpen'
            end
            last_fold_end = vim.fn.foldclosedend(lnum)
            if last_fold_end == -1 then
                vim.cmd(lnum .. 'foldclose')
                last_fold_end = vim.fn.foldclosedend(lnum)
                vim.cmd(lnum .. 'foldopen')
            end
        end

        local prev = cache[lnum]
        if sign_name then
            if not prev or prev.fold ~= sign_name then
                -- Remove previous sign if it exists
                if prev and prev.sign_id then
                    vim.fn.sign_unplace(group, { buffer = buf, id = prev.sign_id })
                end
                local id = tonumber(buf .. lnum)
                assert(id and sign_name)
                local sign_id =
                    vim.fn.sign_place(id, group, sign_name, buf, { lnum = lnum, priority = 1000 })
                if id == sign_id then cache[lnum] = { fold = sign_name, sign_id = id } end
            end
        elseif fold_lvl == 0 then
            -- Remove sign if it is no longer needed
            if prev and prev.sign_id then
                vim.fn.sign_unplace(group, { buffer = buf, id = prev.sign_id })
            end
            cache[lnum] = { fold = nil, sign_id = nil }
        end
    end
end

function M.update_fold_signs(buf)
    buf = buf or 0
    if buf == 0 then buf = vim.api.nvim_get_current_buf() end
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
            local first_visible_line = vim.fn.line('w0', win)
            local last_visible_line = vim.fn.line('w$', win)
            update_range(buf, first_visible_line, last_visible_line)
        end
    end
end

vim.api.nvim_create_autocmd({
    'WinEnter',
    'BufWinEnter',
    'CursorHold',
    'CursorMoved',
    'WinScrolled',
}, {
    callback = function()
        if vim.fn.mode() == 'i' then return end
        M.update_fold_signs()
    end,
})
vim.api.nvim_create_autocmd('BufDelete', {
    callback = function(args) fold_sign_cache[args.buf] = nil end,
})

local fold_keys = {
    {
        value = 'za',
        desc = 'Toggle fold under cursor',
    },
    {
        value = 'zA',
        desc = 'Toggle all folds under cursor',
    },
    {
        value = 'zd',
        desc = 'Delete fold under cursor',
    },
    {
        value = 'zc',
        desc = 'Close fold under cursor',
    },
    {
        value = 'zC',
        desc = 'Close all folds under cursor',
    },
    {
        value = 'zD',
        desc = 'Delete all folds under cursor',
    },
    {
        value = 'zE',
        desc = 'Delete all folds in the buffer',
    },
    {
        value = 'zf',
        desc = 'Create fold',
    },
    {
        value = 'zm',
        desc = 'Fold more',
    },
    {
        value = 'zM',
        desc = 'Close all folds',
    },
    {
        value = 'zo',
        desc = 'Open fold under cursor',
    },
    {
        value = 'zO',
        desc = 'Open all folds under cursor',
    },
    {
        value = 'zr',
        desc = 'Fold less',
    },
    {
        value = 'zR',
        desc = 'Open all folds',
    },
}

for _, key in ipairs(fold_keys) do
    utils.map_set({ 'n', 'x' }, key.value, function()
        vim.schedule(M.update_fold_signs)
        return key.value
    end, { expr = true, desc = key.desc })
end

return M
