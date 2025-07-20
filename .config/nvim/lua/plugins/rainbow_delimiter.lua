-- PERF:
-- This plugin may cause performance issues with large files.
vim.api.nvim_create_autocmd('BufEnter', {
    group = 'UserDIY',
    callback = function(args)
        if require('utils').is_big_file(args.buf) then
            require('rainbow-delimiters').disable(args.buf)
        end
    end,
})
return {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'VeryLazy',
    init = function()
        vim.g.rainbow_delimiters = {
            highlight = {
                'RainbowDelimiterRed',
                'RainbowDelimiterYellow',
                'RainbowDelimiterBlue',
                'RainbowDelimiterOrange',
                'RainbowDelimiterViolet',
                'RainbowDelimiterCyan',
            },
        }
    end,
}
