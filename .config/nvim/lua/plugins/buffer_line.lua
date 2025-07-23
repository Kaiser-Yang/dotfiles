local utils = require('utils')
local function quit_not_save_on_buffer(current_buf, force_delete)
    current_buf = current_buf or 0
    if current_buf == 0 then current_buf = vim.api.nvim_get_current_buf() end
    local tabs = vim.api.nvim_list_tabpages()
    local current_win = vim.api.nvim_get_current_win()
    local current_tab = vim.api.nvim_get_current_tabpage()
    local hold_by_other
    local wins_for_new_target = {}
    local current_tab_visible_bufs = {}
    for _, tab in pairs(tabs) do
        for _, win in pairs(vim.api.nvim_tabpage_list_wins(tab)) do
            local win_buf = vim.api.nvim_win_get_buf(win)
            if win_buf == current_buf and win ~= current_win then hold_by_other = true end
            if win_buf == current_buf and force_delete then
                table.insert(wins_for_new_target, win)
            end
            if utils.is_visible_buffer(win_buf) and tab == current_tab then
                table.insert(current_tab_visible_bufs, win_buf)
            end
        end
    end
    local function get_target_buf(ignore_visible)
        local res
        for _, buf in pairs(utils.get_visible_bufs()) do
            if
                buf == current_buf
                or ignore_visible and vim.tbl_contains(current_tab_visible_bufs, buf)
            then
                goto continue
            end
            local value = _G.buffer_cache.kv_map[buf]
            assert(value, 'cache value for a visible buffer should not be nil')
            if not res then
                res = buf
                goto continue
            end
            local target_buffer_value = _G.buffer_cache.kv_map[res]
            assert(target_buffer_value, 'Target buffer value should not be nil')
            if _G.buffer_cache.gmt_last_vis[res] < _G.buffer_cache.gmt_last_vis[buf] then
                res = buf
            end
            ::continue::
        end
        return res
    end
    if force_delete then
        if #utils.get_visible_bufs() <= 1 then
            vim.cmd('silent! q')
        else
            local target_buffer = get_target_buf()
            assert(target_buffer, 'target_buffer should not be nill for all visible buffers')
            for _, win in pairs(wins_for_new_target) do
                vim.api.nvim_win_set_buf(win, target_buffer)
            end
            vim.cmd('bdelete ' .. current_buf)
        end
        return
    end
    if #tabs > 1 and #current_tab_visible_bufs <= 1 then
        vim.cmd('tabclose')
        if not hold_by_other then vim.cmd('bdelete ' .. current_buf) end
        return
    end
    if not utils.is_visible_buffer(current_buf) or vim.bo.filetype == 'qf' then
        vim.cmd('silent q!')
        return
    end
    if #utils.get_visible_bufs() <= 1 then
        vim.cmd('silent q!')
        return
    end
    local target_buffer = get_target_buf(true)
    assert(
        not vim.tbl_contains(current_tab_visible_bufs, target_buffer),
        'target_buf should not be visible'
    )
    if target_buffer then
        vim.api.nvim_win_set_buf(current_win, target_buffer)
    else
        vim.cmd('silent q!')
    end
    if not hold_by_other then vim.cmd('bdelete ' .. current_buf) end
end
return {
    'akinsho/bufferline.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    version = '*',
    event = 'VeryLazy',
    opts = {
        options = {
            numbers = function(opts)
                local state = require('bufferline.state')
                for i, buf in ipairs(state.components) do
                    if buf.id == opts.id then return tostring(i) end
                end
                return tostring(opts.ordinal)
            end,
            offsets = {
                {
                    filetype = 'neo-tree',
                    text = 'NeoTree',
                    highlight = 'Directory',
                    text_align = 'left',
                },
                {
                    filetype = 'dapui_watches',
                    text = 'DAP',
                    highlight = 'Error',
                    text_align = 'left',
                },
            },
            close_command = function(bufnum) quit_not_save_on_buffer(bufnum, true) end,
            diagnostics = 'nvim_lsp',
            diagnostics_indicator = function(_, _, diagnostics_dict, _)
                local s = ' '
                for e, n in pairs(diagnostics_dict) do
                    local sym = e == 'error' and ' ' or (e == 'warning' and ' ' or '')
                    s = s .. n .. sym
                end
                return s
            end,
            sort_by = 'insert_after_current',
        },
    },
    config = function(_, opts)
        local ok, catppuccin = pcall(require, 'catppuccin.groups.integrations.bufferline')
        if ok then opts.highlights = catppuccin.get() end
        require('bufferline').setup(opts)
    end,
    keys = {
        { 'Q', quit_not_save_on_buffer, desc = 'Smart quit' },
        {
            '<leader>1',
            function() require('bufferline').go_to(1, true) end,
            desc = 'Go to the 1st buffer',
        },
        {
            '<leader>2',
            function() require('bufferline').go_to(2, true) end,
            desc = 'Go to the 2nd buffer',
        },
        {
            '<leader>3',
            function() require('bufferline').go_to(3, true) end,
            desc = 'Go to the 3rd buffer',
        },
        {

            '<leader>4',
            function() require('bufferline').go_to(4, true) end,
            desc = 'Go to the 4th buffer',
        },
        {

            '<leader>5',
            function() require('bufferline').go_to(5, true) end,
            desc = 'Go to the 5th buffer',
        },
        {

            '<leader>6',
            function() require('bufferline').go_to(6, true) end,
            desc = 'Go to the 6th buffer',
        },
        {

            '<leader>7',
            function() require('bufferline').go_to(7, true) end,
            desc = 'Go to the 7th buffer',
        },
        {

            '<leader>8',
            function() require('bufferline').go_to(8, true) end,
            desc = 'Go to the 8th buffer',
        },
        {

            '<leader>9',
            function() require('bufferline').go_to(9, true) end,
            desc = 'Go to the 9th buffer',
        },
        {

            '<leader>0',
            function() require('bufferline').go_to(10, true) end,
            desc = 'Go to the 10th buffer',
        },
        { 'H', '<cmd>BufferLineCyclePrev<cr>', desc = 'Buffer switch left' },
        { 'L', '<cmd>BufferLineCycleNext<cr>', desc = 'Buffer switch right' },
        { 'gb', '<cmd>BufferLinePick<CR>', desc = 'Buffer pick' },
    },
}
