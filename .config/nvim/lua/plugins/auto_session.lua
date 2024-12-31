return {
    'rmagatti/auto-session',
    dependencies = {
        'nvim-neo-tree/neo-tree.nvim',
    },
    opts = {
        suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        post_restore_cmds = {
            function()
                require('neo-tree.command').execute({
                    action = 'show',
                    source = 'filesystem',
                    dir = require('utils').get_root_directory(),
                })
            end,
        },
        auto_create = require('utils').has_root_directory
    }
}
