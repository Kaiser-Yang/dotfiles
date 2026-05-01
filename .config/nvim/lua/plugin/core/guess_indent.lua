local u = require('utils')
local g = require('guess-indent')
g.setup({ on_tab_options = { expandtab = false, shiftwidth = 0, softtabstop = 0, tabstop = 8 } })
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if u.buffer.normal(buf) then g.set_from_buffer(buf, true, true) end
end
