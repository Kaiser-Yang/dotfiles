local M = {}

--- @param keys string
--- @param mode string
function M.feedkeys(keys, mode)
  local termcodes = vim.api.nvim_replace_termcodes(keys, true, true, true)
  vim.api.nvim_feedkeys(termcodes, mode, false)
end

--- Set a map
--- @param mode string|string[]?
--- @param lhs string
--- @param rhs string|function
--- @param opts? vim.keymap.set.Opts default: { silent = true, remap = false, nowait = true }
function M.set(mode, lhs, rhs, opts)
  opts = vim.tbl_extend('force', { silent = true, remap = false, nowait = true }, opts or {})
  mode = mode or 'n'
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M
