return {
    'Kaiser-Yang/win-resizer.nvim',
    lazy = false,
    config = function()
        require('win.resizer').setup({
            ignore_filetypes = {
                'neo-tree',
                'Avante',
                'AvanteInput',
            },
        })
        local resize = require('win.resizer').resize
        local map_set = require('utils').map_set
        local first_left_or_right = 'right'
        local first_top_or_bottom = 'top'
        local second_left_or_right = first_left_or_right == 'right' and 'left' or 'right'
        local second_top_or_bottom = first_top_or_bottom == 'bottom' and 'top' or 'bottom'
        local abs_delta = 3
        local border_to_key = {
            top = '<up>',
            bottom = '<down>',
            left = '<left>',
            right = '<right>',
        }
        local border_to_reverse_key = {
            top = '<s-up>',
            bottom = '<s-down>',
            left = '<s-left>',
            right = '<s-right>',
        }
        for _, border in pairs({ 'top', 'bottom', 'left', 'right' }) do
            local delta = (border == first_left_or_right or border == first_top_or_bottom)
                    and abs_delta
                or -abs_delta
            local first = (border == first_left_or_right or border == second_left_or_right)
                    and first_left_or_right
                or first_top_or_bottom
            local second = first == first_left_or_right and second_left_or_right
                or second_top_or_bottom
            local desc = 'Smart resize ' .. first .. ' ' .. border
            local desc_reverse = 'Smart resize ' .. second .. ' ' .. border
            map_set(
                { 'n' },
                border_to_key[border],
                function()
                    local _ = resize(0, first, delta, true)
                        or resize(0, second, -delta, true)
                        or resize(0, first, delta, false)
                        or resize(0, second, -delta, false)
                end,
                { desc = desc }
            )
            map_set(
                { 'n' },
                border_to_reverse_key[border],
                function()
                    local _ = resize(0, second, -delta, true)
                        or resize(0, first, delta, true)
                        or resize(0, second, -delta, false)
                        or resize(0, first, delta, false)
                end,
                { desc = desc_reverse }
            )
        end
    end,
}
