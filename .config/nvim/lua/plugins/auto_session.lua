local utils = require('utils')
return {
    'rmagatti/auto-session',
    lazy = false,
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
        post_restore_cmds = {
            function()
                vim.g.buffer_limit = vim.g.buffer_limit or 10
                --- @type LFUCache
                _G.buffer_cache = _G.buffer_cache or require('lfu').new(vim.g.buffer_limit)
                -- Make sure the buffer cache is cleared before restoring
                _G.buffer_cache:clear()
                for _, buf in ipairs(utils.get_visible_bufs()) do
                    local deleted_buf, _ = _G.buffer_cache:set(buf, true)
                    if deleted_buf then utils.bufdelete(deleted_buf) end
                end
            end,
        },
    },
}
