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
        keys = {
            quit = { '<esc>', '<c-n>' }
        }
    }
})
