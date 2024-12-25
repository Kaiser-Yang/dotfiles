return {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    dependencies = {
        'rafamadriz/friendly-snippets',
    },
    config = function()
        require('luasnip.loaders.from_vscode').lazy_load({
            paths = { vim.fn.expand('~/.config/nvim/snippets') }
        })
    end,
}
