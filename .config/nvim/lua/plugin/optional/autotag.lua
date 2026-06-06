local u = require('utils')
u.gh('tronikelis/ts-autotag.nvim')
require('ts-autotag').setup({
  auto_rename = { enabled = true },
  should_attach = function(buf) return u.enabled('autotag', buf) end,
})
local config = require('ts-autotag.config').config
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if
    vim.tbl_contains(config.filetypes, vim.bo[buf].filetype)
    and u.treesitter_available(buf)
    and config.should_attach(buf)
  then
    require('ts-autotag.rename_tag.auto').init(buf)
    require('ts-autotag.close_tag').init(buf)
  end
end
