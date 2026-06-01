local u = require('utils')
u.gh('tronikelis/ts-autotag.nvim')
require('ts-autotag').setup({
  auto_rename = { enabled = true },
  should_attach = function(buf) return not vim.b[buf].autotag end,
})
local config = require('ts-autotag.config').config
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.tbl_contains(config.filetypes, vim.bo[buf].filetype) and u.treesitter_available(buf) then
    if config.should_attach(buf) then
      if config.auto_rename.enabled then require('ts-autotag.rename_tag.auto').init(buf) end
      if config.auto_close.enabled then require('ts-autotag.close_tag').init(buf) end
    end
  end
end
