local utils = require('utils')
return {
    'rmagatti/auto-session',
    dependencies = {
        'nvim-neo-tree/neo-tree.nvim',
    },
    opts = {
        suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        post_restore_cmds = {
            function()
                -- require('neo-tree.command').execute({
                --     action = 'show',
                --     source = 'filesystem',
                --     dir = utils.get_root_directory(),
                -- })
                -- vim.cmd('wincmd =')
            end,
        },
        auto_save = utils.has_root_directory,
        auto_create = utils.has_root_directory,
        auto_restore = utils.has_root_directory,
        git_use_branch_name = true,
        git_auto_restore_on_branch_change = true,
        continue_restore_on_error = false,
        session_lens = {
            mappings = {
                delete_session = false,
                alternate_session = false,
                copy_session = false,
            },
        },
    },
}
