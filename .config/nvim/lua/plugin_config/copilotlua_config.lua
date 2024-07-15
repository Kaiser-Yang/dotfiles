require('copilot').setup({
    panel = {
        enabled = false,
        -- auto_refresh = false,
        -- keymap = {
        --     jump_prev = false,
        --     jump_next = false,
        --     accept = false,
        --     refresh = false,
        --     open = false
        -- },
        -- layout = {
        --     position = "right", -- | top | left | right
        --     ratio = 0.4
        -- },
    },
    suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        debounce = 75,
        keymap = {
            accept = false,
            accept_word = false,
            accept_line = false,
            next = false,
            prev = false,
            dismiss = false,
        },
    },
    filetypes = {
        ['*'] = true,
        -- help = false,
        -- yaml = false,
        -- markdown = false,
        -- gitcommit = false,
        -- gitrebase = false,
        -- hgcommit = false,
        -- svn = false,
        -- cvs = false,
        -- ["."] = false,
    },
    copilot_node_command = 'node', -- Node.js version must be > 18.x
    server_opts_overrides = {},
})
