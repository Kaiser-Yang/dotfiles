local utils = require('utils')
return {
    'rmagatti/auto-session',
    dependencies = {
        'nvim-neo-tree/neo-tree.nvim',
    },
    opts = {
        suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
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
