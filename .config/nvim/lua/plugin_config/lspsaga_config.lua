require('lspsaga').setup({
    outline = {
        win_position = 'right',
        keys = {
            jump = '<cr>',
            toggle_or_jump = 'o',
            quit = { 'q' }
        }
    },
    code_action = {
        -- extend_gitsigns = true,
        keys = {
            quit = { 'q', '<esc>', '<c-n>' },
            exec = '<cr>'
        }
    },
    diagnostic = {
        keys = {
            quit = { 'q', '<esc>', '<c-n>' },
            quit_in_show = { 'q', '<esc>', '<c-n>' },
        }
    },
    hover = {
        open_cmd = '!wslview'
    },
    rename = {
        in_select = false,
        keys = {
            quit = { 'Q', 'q' }
        }
    },
    lightbulb = {
        enable = false,
        sign = true,
        virtual_text = false,
        sign_priority = 1,
    },
})
