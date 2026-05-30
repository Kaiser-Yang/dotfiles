local u = require('utils')
local M = {}

function M.help()
  if not _G.loaded['grug-far.nvim'] or vim.bo.filetype ~= 'grug-far' then return false end
  vim.cmd.stopinsert()
  u.grug_inst():help()
  return true
end

return M
