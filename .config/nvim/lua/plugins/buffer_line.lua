local utils = require('utils')
return {
    'akinsho/bufferline.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'catppuccin/nvim',
        'folke/snacks.nvim',
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
                    return tostring(opts.ordinal)
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
                    if #utils.get_visible_bufs() > 1 then
                        require('snacks').bufdelete(bufnum)
                    else
                        vim.cmd('silent qa!')
                    end
                end,
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
                -- BUG:
                -- Hover not working
                hover = {
                    enabled = true,
                    delay = 50,
                    reveal = { 'close' },
                },
            },
        })
        local function quit_not_save_on_buffer()
            if
                not utils.is_visible_buffer(vim.api.nvim_get_current_buf())
                or vim.buf.filetype == 'qf'
            then
                vim.cmd('silent q!')
                return
            end
            if #utils.get_visible_bufs() > 1 then
                Snacks.bufdelete()
                return
            end
            local current_tab_visible_buf = 0
            for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
                if utils.is_visible_buffer(vim.api.nvim_win_get_buf(win)) then
                    current_tab_visible_buf = current_tab_visible_buf + 1
                end
            end
            if current_tab_visible_buf > 1 then
                vim.cmd('silent q!')
            else
                vim.cmd('silent qa!')
            end
        end

        local map_set = utils.map_set
        map_set({ 'n' }, 'Q', quit_not_save_on_buffer)
        map_set(
            { 'n' },
            '<leader>1',
            function() buffer_line.go_to(1, true) end,
            { desc = 'Go to the 1st buffer' }
        )
        map_set(
            { 'n' },
            '<leader>2',
            function() buffer_line.go_to(2, true) end,
            { desc = 'Go to the 2nd buffer' }
        )
        map_set(
            { 'n' },
            '<leader>3',
            function() buffer_line.go_to(3, true) end,
            { desc = 'Go to the 3rd buffer' }
        )
        map_set(
            { 'n' },
            '<leader>4',
            function() buffer_line.go_to(4, true) end,
            { desc = 'Go to the 4th buffer' }
        )
        map_set(
            { 'n' },
            '<leader>5',
            function() buffer_line.go_to(5, true) end,
            { desc = 'Go to the 5th buffer' }
        )
        map_set(
            { 'n' },
            '<leader>6',
            function() buffer_line.go_to(6, true) end,
            { desc = 'Go to the 6th buffer' }
        )
        map_set(
            { 'n' },
            '<leader>7',
            function() buffer_line.go_to(7, true) end,
            { desc = 'Go to the 7th buffer' }
        )
        map_set(
            { 'n' },
            '<leader>8',
            function() buffer_line.go_to(8, true) end,
            { desc = 'Go to the 8th buffer' }
        )
        map_set(
            { 'n' },
            '<leader>9',
            function() buffer_line.go_to(9, true) end,
            { desc = 'Go to the 9th buffer' }
        )
        map_set(
            { 'n' },
            '<leader>0',
            function() buffer_line.go_to(10, true) end,
            { desc = 'Go to the 10th buffer' }
        )
        map_set({ 'n' }, 'H', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Buffer switch left' })
        map_set({ 'n' }, 'L', '<cmd>BufferLineCycleNext<cr>', { desc = 'Buffer switch right' })
        map_set({ 'n' }, 'gb', '<cmd>BufferLinePick<CR>', { desc = 'Buffer pick' })
    end,
}
