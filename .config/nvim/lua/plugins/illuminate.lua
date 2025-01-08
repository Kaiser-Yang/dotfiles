return {
    'RRethy/vim-illuminate',
    config = function()
        require('illuminate').configure({
            should_enable = function(_)
                return vim.fn.wordcount().bytes < vim.g.big_file_limit
            end,
            providers = {
                'lsp',
                'treesitter',
                'regex',
            },
            delay = 100,
            filetypes_denylist = {
                'dirbuf',
                'dirvish',
                'fugitive',
                'neo-tree',
            },
            under_cursor = true,
            min_count_to_highlight = 1,
            case_insensitive_regex = false,
        })
    end
}
