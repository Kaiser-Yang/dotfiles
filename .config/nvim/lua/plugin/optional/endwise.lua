local u = require('utils')
vim.pack.add({ u.gh('RRethy/nvim-treesitter-endwise') }, { confirm = false })

require('nvim-treesitter-endwise').init()
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if u.buffer.normal(buf) then
    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
    if require('nvim-treesitter-endwise').is_supported(lang) then require('nvim-treesitter.endwise').attach(buf) end
  end
end
