return {
    'akinsho/bufferline.nvim',
    dependencies = {
        'catppuccin/nvim',
        'famiu/bufdelete.nvim',
    },
    version = '*',
    config = function()
        local buffer_line = require('bufferline')
        buffer_line.setup({
            highlights = require('catppuccin.groups.integrations.bufferline').get(),
            options = {
                numbers = function(opts)
                    local state = require('bufferline.state')
                    for i, buf in ipairs(state.components) do
                        if buf.id == opts.id then return tostring(i) end
                    end
                    return opts.ordinal
                end,
                offsets = {
                    {
                        filetype = 'neo-tree',
                        text = 'NeoTree',
                        highlight = 'Directory',
                        text_align = 'left',
                    },
                },
                close_command = function(bufnum)
                    -- when closing some files, this function will throw a exception
                    -- I don't know how to fix, just ignore this exception
                    pcall(require('bufdelete').bufdelete, bufnum, true)
                end,
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(_, _, diagnostics_dict, _)
                    local s = " "
                    for e, n in pairs(diagnostics_dict) do
                        local sym = e == "error" and " " or (e == "warning" and " " or "")
                        s = s .. n .. sym
                    end
                    return s
                end,
                sort_by = 'insert_after_current',
                hover = {
                    enabled = true,
                    delay = 50,
                    reveal = { 'close' }
                }
            }
        })
        local utils = require('utils')
        local function auto_close_empty_buffer()
            local current_tab_win_cnt = vim.api.nvim_tabpage_list_wins(0)
            local current_tab_hiddent_buf_cnt = 0
            local current_tab_empty_buffers = {}
            for _, win in ipairs(current_tab_win_cnt) do
                local buf = vim.api.nvim_win_get_buf(win)
                if utils.is_visible_buffer(buf) then
                    local filetype = vim.api.nvim_get_option_value('filetype', { buf = buf })
                    if filetype == nil or filetype == "" then
                        if utils.is_empty_buffer(buf) then
                            current_tab_empty_buffers[#current_tab_empty_buffers + 1] = buf
                        else
                            return
                        end
                    else
                        return
                    end
                else
                    current_tab_hiddent_buf_cnt = current_tab_hiddent_buf_cnt + 1
                end
            end
            -- unload all empty buffers
            for _, buf in ipairs(current_tab_empty_buffers) do
                vim.cmd('silent bd! ' .. buf)
            end
            if #vim.api.nvim_list_tabpages() > 1 then
                if current_tab_hiddent_buf_cnt > 0 then
                    vim.cmd('silent tabclose!')
                end
            else
                vim.cmd('qa!')
            end
        end

        local function quit_not_save_on_buffer()
            if not utils.is_visible_buffer(vim.api.nvim_get_current_buf()) then
                vim.cmd('silent q!')
                return
            end
            local current_tab_visible_buf_cnt = 0
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                if utils.is_visible_buffer(vim.api.nvim_win_get_buf(win)) then
                    current_tab_visible_buf_cnt = current_tab_visible_buf_cnt + 1
                end
            end
            if current_tab_visible_buf_cnt > 1 then
                vim.cmd('silent q')
                return
            end
            local visible_buf_cnt = 0
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if utils.is_visible_buffer(buf) then
                    visible_buf_cnt = visible_buf_cnt + 1
                end
            end
            local tab_cnt = #vim.api.nvim_list_tabpages()
            if tab_cnt == 1 and visible_buf_cnt > 1 then
                pcall(require("bufdelete").bufdelete, 0, true)
                auto_close_empty_buffer()
            elseif tab_cnt > 1 then
                vim.cmd('silent q!')
                auto_close_empty_buffer()
            elseif visible_buf_cnt == 1 then
                vim.cmd('silent qa!')
            end
        end

        local map_set = utils.map_set
        map_set({ 'n' }, 'Q', quit_not_save_on_buffer)
        map_set({ 'n' }, 'S', function()
            vim.cmd('w')
            quit_not_save_on_buffer()
        end)
        map_set({ 'n' }, '<leader>1', function() buffer_line.go_to(1, true) end,
            { desc = 'Go to the 1st buffer' })
        map_set({ 'n' }, '<leader>2', function() buffer_line.go_to(2, true) end,
            { desc = 'Go to the 2nd buffer' })
        map_set({ 'n' }, '<leader>3', function() buffer_line.go_to(3, true) end,
            { desc = 'Go to the 3rd buffer' })
        map_set({ 'n' }, '<leader>4', function() buffer_line.go_to(4, true) end,
            { desc = 'Go to the 4th buffer' })
        map_set({ 'n' }, '<leader>5', function() buffer_line.go_to(5, true) end,
            { desc = 'Go to the 5th buffer' })
        map_set({ 'n' }, '<leader>6', function() buffer_line.go_to(6, true) end,
            { desc = 'Go to the 6th buffer' })
        map_set({ 'n' }, '<leader>7', function() buffer_line.go_to(7, true) end,
            { desc = 'Go to the 7th buffer' })
        map_set({ 'n' }, '<leader>8', function() buffer_line.go_to(8, true) end,
            { desc = 'Go to the 8th buffer' })
        map_set({ 'n' }, '<leader>9', function() buffer_line.go_to(9, true) end,
            { desc = 'Go to the 9th buffer' })
        map_set({ 'n' }, '<leader>0', function() buffer_line.go_to(10, true) end,
            { desc = 'Go to the 10th buffer' })
        map_set({ 'n' }, 'H', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Buffer switch left' })
        map_set({ 'n' }, 'L', '<cmd>BufferLineCycleNext<cr>', { desc = 'Buffer switch right' })
        map_set({ 'n' }, "gb", "<cmd>BufferLinePick<CR>", { desc = 'Buffer pick' })
    end
}
