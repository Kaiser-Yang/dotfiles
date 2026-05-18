local u = require('utils')

local M = {
  builtin = require('handler.builtin'),
  completion = require('handler.completion'),
  dap = require('handler.dap'),
  git = require('handler.git'),
  markdown = require('handler.markdown'),
  nvim_tree = require('handler.nvim_tree'),
  pair = require('handler.pair'),
  repmove = require('handler.repmove'),
  telescope = require('handler.telescope'),
  treesitter = require('handler.treesitter'),
}

M = vim.tbl_deep_extend('error', M, require('handler.completion'))
M = vim.tbl_deep_extend('error', M, require('handler.markdown'))
M = vim.tbl_deep_extend('error', M, require('handler.pair'))
M = vim.tbl_deep_extend('error', M, require('handler.treesitter'))
M = vim.tbl_deep_extend('error', M, require('handler.repmove'))
M = vim.tbl_deep_extend('error', M, require('handler.blink_indent'))
M = vim.tbl_deep_extend('error', M, require('handler.telescope'))
M = vim.tbl_deep_extend('error', M, require('handler.git'))
M = vim.tbl_deep_extend('error', M, require('handler.nvim_tree'))
M = vim.tbl_deep_extend('error', M, require('handler.dap'))

function M.async_format()
  local buf = vim.api.nvim_get_current_buf()
  local res = require('conform').format({ async = true }, function(err)
    if err then return end
    vim.schedule_wrap(require('guess-indent').set_from_buffer)(buf, true, true)
  end)
  if res ~= nil then return res end
  return true
end

local first_to_second = {
  top = 'bottom',
  bottom = 'top',
  left = 'right',
  right = 'left',
}
--- @param border 'top' | 'bottom' | 'left' | 'right'
--- @param reverse? boolean
--- @param abs_delta? integer
--- @param first 'top' | 'bottom' | 'left' | 'right' | nil
function M.resize_wrap(border, reverse, abs_delta, first)
  abs_delta = abs_delta or 3
  first = first or vim.tbl_contains({ 'left', 'right' }, border) and 'right' or 'top'
  local second = first_to_second[first]
  local delta = (border == first) and abs_delta or -abs_delta
  return function()
    local resize = require('win.resizer').resize
    local actual_delta = delta * vim.v.count1
    if reverse then
      return resize(0, second, -actual_delta, true)
        or resize(0, first, actual_delta, true)
        or resize(0, second, -actual_delta, false)
        or resize(0, first, actual_delta, false)
    else
      return resize(0, first, actual_delta, true)
        or resize(0, second, -actual_delta, true)
        or resize(0, first, actual_delta, false)
        or resize(0, second, -actual_delta, false)
    end
  end
end

function M.toggle_context()
  local c = require('treesitter-context')
  local status = not c.enabled()
  u.toggle_notify('Treesitter Context', status, { title = 'Context' })
  c.toggle()
  return true
end

return M
