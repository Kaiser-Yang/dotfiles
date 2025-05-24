return {
    'HiPhish/rainbow-delimiters.nvim',
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
