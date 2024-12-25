return {
    'RRethy/vim-illuminate',
    config = function()
        require('illuminate').configure({
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
                'NvimTree',
            },
            under_cursor = true,
            min_count_to_highlight = 1,
            case_insensitive_regex = false,
        })
    end
}
