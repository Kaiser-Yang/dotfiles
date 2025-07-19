local utils = require('utils')
local function quit_not_save_on_buffer()
    if #vim.api.nvim_list_tabpages() > 1 then
        local current_tab_visible_buf = 0
        for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if utils.is_visible_buffer(vim.api.nvim_win_get_buf(win)) then
                current_tab_visible_buf = current_tab_visible_buf + 1
            end
        end
        if current_tab_visible_buf <= 1 then
            vim.cmd('tabclose')
            return
        end
    end
    if
        not utils.is_visible_buffer(vim.api.nvim_get_current_buf())
        or vim.bo.filetype == 'qf'
        or vim.bo.filetype:match('^dap')
    then
        vim.cmd('silent q!')
        return
    end
    if #utils.get_visible_bufs() > 1 then
        utils.bufdelete()
        return
    end
    vim.cmd('silent q!')
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
            close_command = function(bufnum)
                if #utils.get_visible_bufs() > 1 then
                    utils.bufdelete(bufnum)
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
