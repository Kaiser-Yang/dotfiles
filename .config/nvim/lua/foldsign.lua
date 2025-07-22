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

function M.update_fold_signs(buf)
    local cache = get_buf_cache(buf)
    local first_visible_line = vim.fn.line('w0')
    local last_visible_line = vim.fn.line('w$')
    local changed = buf_tick_cache[buf] ~= get_buf_tick(buf)

    for lnum = first_visible_line, last_visible_line do
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
                local id = lnum
                assert(sign_name)
                vim.fn.sign_place(id, group, sign_name, buf, { lnum = lnum, priority = 1000 })
                cache[lnum] = { fold = fold_status, sign_id = id }
            end
        else
            -- Remove sign if it is no longer needed
            if prev and prev.sign_id then
                vim.fn.sign_unplace(group, { buffer = buf, id = prev.sign_id })
            end
            cache[lnum] = { fold = nil, sign_id = nil }
        end
        ::continue::
    end

    if not changed then return end
    -- Only remove the unavailable signs, when changed
    for lnum, _ in pairs(cache) do
        if lnum < first_visible_line or lnum > last_visible_line then
            local prev = cache[lnum]
            if prev and prev.sign_id then
                vim.fn.sign_unplace(group, { buffer = buf, id = prev.sign_id })
            end
            cache[lnum] = nil
        end
    end
end

vim.api.nvim_create_autocmd('CursorMoved', {
    callback = function(args) M.update_fold_signs(args.buf) end,
})

return M
