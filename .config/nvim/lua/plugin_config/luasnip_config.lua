vim.api.nvim_create_autocmd(
    { "VimEnter" },
    { callback = require("luasnip.loaders.from_vscode").lazy_load }
)
