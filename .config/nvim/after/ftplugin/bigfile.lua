vim.b.lint = false
vim.b.color = false
vim.g.flash = false
vim.b.pairs = false
vim.b.autotag = false
vim.b.conform = false
vim.b.treesitter_foldexpr = false
vim.b.treesitter_highlight = false
local bufnr = vim.api.nvim_get_current_buf()
for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
  vim.lsp.buf_detach_client(bufnr, client.id)
end
