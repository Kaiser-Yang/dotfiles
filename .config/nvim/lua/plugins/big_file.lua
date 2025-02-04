return {
    'ouuan/nvim-bigfile',
    opts = {
        size_limit = vim.g.big_file_limit,
        -- Per-filetype size limits
        ft_size_limits = {
            -- javascript = 100 * 1024, -- 100KB for javascript files
        },
        -- Show notifications when big files are detected
        notification = false,
        syntax = true,
        hook = nil,
    }
}
