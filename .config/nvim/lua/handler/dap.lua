local M = {}
local u = require('utils')

local function get_current_breakpoint()
  local buf = vim.api.nvim_get_current_buf()
  local breakpoints = require('dap.breakpoints').get(buf)[buf]
  if not breakpoints then return nil end
  local line = vim.api.nvim_win_get_cursor(0)[1]
  for _, b in ipairs(breakpoints) do
    if b.line == line then return b end
  end
  return nil
end

M.toggle_virtual_text = function()
  if not _G.loaded['nvim-dap-view'] then return false end
  local status = not require('dap-view.setup').config.virtual_text.enabled
  require('dap-view.virtual-text').set_virtual_text(status)
  u.toggle_notify('Dap Virtual Text', status, { title = 'Dap View' })
  return true
end

function M.toggle_dap_view()
  if not _G.loaded['nvim-dap-view'] then return false end
  if _G.loaded['nvim-tree.lua'] then
    local tree = require('nvim-tree.api').tree
    local winnr = require('dap-view.state').winnr
    local dap_view_visible = winnr and vim.api.nvim_win_is_valid(winnr)
    if tree.is_visible() and not dap_view_visible then tree.close() end
  end
  require('dap-view').toggle()
  return true
end

function M.restart_or_run_last()
  if not _G.loaded['nvim-dap'] then return false end
  local dap = require('dap')
  if dap.session() then
    dap.restart()
  else
    dap.run_last()
  end
  return true
end

M.set_hit_count_breakpoint = function()
  if not _G.loaded['nvim-dap'] then return false end
  local bp = get_current_breakpoint()
  local default = bp and bp.hitCondition or nil
  vim.ui.input({ prompt = 'Hit Count Breakpoint', default = default, normal = default ~= nil }, function(input)
    if input and input ~= '' and input ~= default then require('dap').set_breakpoint(nil, input) end
  end)
  return true
end

M.set_condition_breakpoint = function()
  if not _G.loaded['nvim-dap'] then return false end
  local bp = get_current_breakpoint()
  local default = bp and bp.condition or nil
  vim.ui.input({ prompt = 'Condition Breakpoint', default = default, normal = default ~= nil }, function(input)
    if input and input ~= '' and input ~= default then require('dap').set_breakpoint(input) end
  end)
  return true
end

M.set_log_point = function()
  if not _G.loaded['nvim-dap'] then return false end
  local bp = get_current_breakpoint()
  local default = bp and bp.logMessage or nil
  vim.ui.input({ prompt = 'Log Point', default = default, normal = default ~= nil }, function(input)
    if input and input ~= '' and input ~= default then require('dap').set_breakpoint(nil, nil, input) end
  end)
  return true
end

M.toggle_breakpoint = function()
  if not _G.loaded['nvim-dap'] then return false end
  require('dap').toggle_breakpoint()
  return true
end

M.clear_breakpoints = function()
  if not _G.loaded['nvim-dap'] then return false end
  require('dap').clear_breakpoints()
  return true
end

M.terminate = function()
  if not _G.loaded['nvim-dap'] then return false end
  require('dap').terminate()
  return true
end

M.continue = function()
  if not _G.loaded['nvim-dap'] then return false end
  require('dap').continue()
  return true
end

M.step_back = function()
  if not _G.loaded['nvim-dap'] then return false end
  require('dap').step_back()
  return true
end

M.step_over = function()
  if not _G.loaded['nvim-dap'] then return false end
  require('dap').step_over()
  return true
end

M.step_into = function()
  if not _G.loaded['nvim-dap'] then return false end
  require('dap').step_into()
  return true
end

M.step_out = function()
  if not _G.loaded['nvim-dap'] then return false end
  require('dap').step_out()
  return true
end

M.run_to_cursor = function()
  if not _G.loaded['nvim-dap'] then return false end
  require('dap').run_to_cursor()
  return true
end

M.reverse_continue = function()
  if not _G.loaded['nvim-dap'] then return false end
  require('dap').reverse_continue()
  return true
end

M.set_exception_breakpoints = function()
  if not _G.loaded['nvim-dap'] then return false end
  require('dap').set_exception_breakpoints()
  return true
end

return M
