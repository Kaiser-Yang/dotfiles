return {
    'rmagatti/auto-session',
    dependencies = {
        'nvim-telescope/telescope.nvim'
    },
    config = function()
        require('auto-session').setup({
            suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
            post_restore_cmds = {
                function()
                    require('nvim-tree.api').tree.toggle({
                        path = require('utils').get_root_directory(),
                        focus = false
                    });
                end
            },
            auto_create = require('utils').has_root_directory
        })
    end,
}
