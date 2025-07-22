vim.fn.sign_define(
    'FoldClosedSign',
    { text = vim.opt.fillchars:get().foldclose or '-', texthl = 'Folded' }
)
vim.fn.sign_define(
    'FoldOpenSign',
    { text = vim.opt.fillchars:get().foldopen or '+', texthl = 'Folded' }
)

local group = 'foldsign'
local fold_sign_cache = {}
local buf_tick_cache = {}
local M = {}

local function get_buf_cache(buf)
    if not fold_sign_cache[buf] then fold_sign_cache[buf] = {} end
    return fold_sign_cache[buf]
end

local function get_buf_tick(buf) return vim.api.nvim_buf_get_changedtick(buf) end

local function update_range(buf, first, last)
    local cache = get_buf_cache(buf)
    local changed = buf_tick_cache[buf] ~= get_buf_tick(buf)
    for lnum = first, last do
        local fold_lvl = vim.fn.foldlevel(lnum)
        local closed = vim.fn.foldclosed(lnum) == lnum
        local fold_status = nil
        local sign_name = nil

        -- We have a cache for the buffer, check if the line number is already processed
        if not changed and cache[lnum] then goto continue end

        -- Calculate the new fold status and sign name
        if fold_lvl > 0 then
            if closed then
                fold_status = 'closed'
                sign_name = 'FoldClosedSign'
            -- FIX:
            -- This may disappear the sign when the fold is open for adjent fold block
            elseif vim.fn.foldclosed(lnum) == -1 and fold_lvl > vim.fn.foldlevel(lnum - 1) then
                fold_status = 'open'
                sign_name = 'FoldOpenSign'
            end
        end

        local prev = cache[lnum]
        if fold_status then
            if not prev or prev.fold ~= fold_status then
                -- Remove previous sign if it exists
                if prev and prev.sign_id then
                    vim.fn.sign_unplace(group, { buffer = buf, id = prev.sign_id })
                end
                local id = tonumber(buf .. lnum)
                assert(id and sign_name)
                vim.fn.sign_place(id, group, sign_name, buf, { lnum = lnum, priority = 1000 })
                cache[lnum] = { fold = fold_status, sign_id = id }
            end
        elseif fold_lvl == 0 then
            -- Remove sign if it is no longer needed
            if prev and prev.sign_id then
                vim.fn.sign_unplace(group, { buffer = buf, id = prev.sign_id })
            end
            cache[lnum] = { fold = nil, sign_id = nil }
        end
        ::continue::
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
    'VimEnter',
    'WinEnter',
    'ModeChanged',
    'CursorHold',
    'CursorMoved',
    'WinScrolled',
    'BufWinEnter',
}, {
    callback = function()
        if vim.fn.mode() == 'i' then return end
        M.update_fold_signs()
    end,
})
vim.api.nvim_create_autocmd('BufDelete', {
    callback = function(args)
        buf_tick_cache[args.buf] = nil
        fold_sign_cache[args.buf] = nil
    end,
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
    require('utils').map_set({ 'n', 'x' }, key.value, function()
        vim.schedule(M.update_fold_signs)
        return key.value
    end, { expr = true, desc = key.desc })
end

return M
