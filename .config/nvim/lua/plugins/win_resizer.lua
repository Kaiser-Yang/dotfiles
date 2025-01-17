return {
    'Kaiser-Yang/win-resizer.nvim',
    lazy = false,
    config = function()
        require('win.resizer').setup({
            ignore_filetypes = {
                'neo-tree',
                'Avante',
                'AvanteInput',
            }
        })
        local resize = require('win.resizer').resize
        local map_set = require('utils').map_set
        local delta = 3
        map_set({ 'n' }, '<up>', function()
            local _ = resize(0, 'top', delta, true) or
                resize(0, 'bottom', -delta, true) or
                resize(0, 'top', delta, false) or
                resize(0, 'bottom', -delta, false)
        end, { desc = 'Smart resize up' })
        map_set({ 'n' }, '<down>', function()
            local _ = resize(0, 'top', -delta, true) or
                resize(0, 'bottom', delta, true) or
                resize(0, 'top', -delta, false) or
                resize(0, 'bottom', delta, false)
        end, { desc = 'Smart resize down' })
        map_set({ 'n' }, '<left>', function()
            local _ = resize(0, 'right', -delta, true) or
                resize(0, 'left', delta, true) or
                resize(0, 'right', -delta, false) or
                resize(0, 'left', delta, false)
        end, { desc = 'Smart resize left' })
        map_set({ 'n' }, '<right>', function()
            local _ = resize(0, 'right', delta, true) or
                resize(0, 'left', -delta, true) or
                resize(0, 'right', delta, false) or
                resize(0, 'left', -delta, false)
        end, { desc = 'Smart resize right' })

        -- or use this below

        -- map_set({ 'n' }, '<up>', function()
        --     resize(0, 'top', delta, true)
        -- end, { desc = 'Increase top border' })
        -- map_set({ 'n' }, '<s-up>', function()
        --     resize(0, 'top', -delta, true)
        -- end, { desc = 'Decrease top border' })
        -- map_set({ 'n' }, '<right>', function()
        --     resize(0, 'right', delta, true)
        -- end, { desc = 'Increase right border' })
        -- map_set({ 'n' }, '<s-right>', function()
        --     resize(0, 'right', -delta, true)
        -- end, { desc = 'Decrease right border' })
        -- map_set({ 'n' }, '<down>', function()
        --     resize(0, 'bottom', delta, true)
        -- end, { desc = 'Increase bottom border' })
        -- map_set({ 'n' }, '<s-down>', function()
        --     resize(0, 'bottom', -delta, true)
        -- end, { desc = 'Decrease bottom border' })
        -- map_set({ 'n' }, '<left>', function()
        --     resize(0, 'left', delta, true)
        -- end, { desc = 'Increase left border' })
        -- map_set({ 'n' }, '<s-left>', function()
        --     resize(0, 'left', -delta, true)
        -- end, { desc = 'Decrease left border' })
    end
}
