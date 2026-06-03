local u = require('utils')
u.gh('Kaiser-Yang/nvim-treesitter-endwise')
local e = require('nvim-treesitter-endwise')

e.init()
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if u.buffer.normal(buf) then
    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
    if e.is_supported(lang) then require('nvim-treesitter.endwise').attach(buf) end
  end
end
