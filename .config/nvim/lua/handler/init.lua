local M = {}
local u = require('utils')

M = vim.tbl_deep_extend('error', M, require('handler.builtin'))
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
    if not u.enabled('conform_on_save_reguess_indent') or err then return end
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
--- @param reverse boolean
--- @param abs_delta integer
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

function M.competi_test()
  if not vim.fn.getcwd():match('OJProblems') then return false end
  if vim.bo.buftype == 'nofile' then
    vim.cmd('CompetiTest receive problem')
    return true
  end
  if not vim.fn.expand('%:p'):match('OJProblems') or vim.bo.filetype ~= 'cpp' then return false end
  local file_dir = vim.fn.expand('%:p:h')
  local file_name = vim.fn.expand('%:t:r')
  if vim.fn.filereadable(file_dir .. '/' .. file_name .. '_0.in') == 0 then
    vim.cmd('CompetiTest receive testcases')
    return true
  end
  vim.cmd('CompetiTest run')
  return true
end

function M.competi_test_receive_file()
  if not vim.fn.getcwd():match('OJProblems') then return false end
  vim.cmd('CompetiTest receive problem')
  return true
end

return M
