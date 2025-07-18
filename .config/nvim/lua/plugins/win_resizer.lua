local first_left_or_right = 'right'
local first_top_or_bottom = 'top'
local second_left_or_right = first_left_or_right == 'right' and 'left' or 'right'
local second_top_or_bottom = first_top_or_bottom == 'bottom' and 'top' or 'bottom'
local abs_delta = 3
--- @param border 'top' | 'bottom' | 'left' | 'right'
local function resize_wrapper(border, reverse)
    local delta = (border == first_left_or_right or border == first_top_or_bottom) and abs_delta
        or -abs_delta
    local first = (border == first_left_or_right or border == second_left_or_right)
            and first_left_or_right
        or first_top_or_bottom
    local second = first == first_left_or_right and second_left_or_right or second_top_or_bottom
    return function()
        local resize = require('win.resizer').resize
        if reverse then
            local _ = resize(0, second, -delta, true)
                or resize(0, first, delta, true)
                or resize(0, second, -delta, false)
                or resize(0, first, delta, false)
        else
            local _ = resize(0, first, delta, true)
                or resize(0, second, -delta, true)
                or resize(0, first, delta, false)
                or resize(0, second, -delta, false)
        end
    end
end
return {
    'Kaiser-Yang/win-resizer.nvim',
    opts = {
        ignore_filetypes = {
            'neo-tree',
            'Avante',
            'AvanteInput',
        },
    },
    keys = {
        {
            '<up>',
            resize_wrapper('top'),
            desc = 'Resize window up',
        },
        {
            '<down>',
            resize_wrapper('bottom'),
            desc = 'Resize window down',
        },
        {
            '<left>',
            resize_wrapper('left'),
            desc = 'Resize window left',
        },
        {
            '<right>',
            resize_wrapper('right'),
            desc = 'Resize window right',
        },
        {
            '<s-up>',
            resize_wrapper('top', true),
            desc = 'Resize window up (reverse)',
        },
        {
            '<s-down>',
            resize_wrapper('bottom', true),
            desc = 'Resize window down (reverse)',
        },
        {
            '<s-left>',
            resize_wrapper('left', true),
            desc = 'Resize window left (reverse)',
        },
        {
            '<s-right>',
            resize_wrapper('right', true),
            desc = 'Resize window right (reverse)',
        },
    },
    config = function(_, opts) require('win.resizer').setup(opts) end,
}
