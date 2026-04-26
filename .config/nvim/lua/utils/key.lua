local M = {}

--- @type string?
local last_key = nil
vim.on_key(function(key, typed) last_key = typed or key end, nil)
function M.last_key() return last_key end

--- @param keys string
--- @param mode string
--- @param replace_keycodes boolean?
function M.feedkeys(keys, mode, replace_keycodes)
  local termcodes = keys
  if replace_keycodes or replace_keycodes == nil then termcodes = M.termcodes(keys) end
  vim.api.nvim_feedkeys(termcodes, mode, false)
end

--- @param keys string
--- @return string
function M.termcodes(keys) return vim.api.nvim_replace_termcodes(keys, true, true, true) end

return M
