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

local win
function M.show_breakpoint_info()
  local bp = get_current_breakpoint()
  if not bp then
    vim.notify('No breakpoint at current line')
    return
  end

  local lines = {
    string.format('Buffer: %d', bp.buf),
    string.format('Line:   %d', bp.line),
    string.format('State:  %s', bp.state or 'enabled'),
  }
  if bp.condition and bp.condition ~= '' then table.insert(lines, string.format('Condition: %s', bp.condition)) end
  if bp.hitCondition and bp.hitCondition ~= '' then
    table.insert(lines, string.format('Hit Count: %s', bp.hitCondition))
  end
  if bp.logMessage and bp.logMessage ~= '' then table.insert(lines, string.format('Log Message: %s', bp.logMessage)) end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  local title = ' Breakpoint Details '
  local width = #title
  for _, line in ipairs(lines) do
    width = math.max(width, #line)
  end
  width = math.min(width, 80)
  local height = #lines
  local winline = vim.fn.winline()
  local winheight = vim.api.nvim_win_get_height(0)
  local row = 1
  if winheight - winline < height + 3 then row = -height - 2 end
  local opts = {
    relative = 'cursor',
    width = width,
    height = height,
    col = 0,
    row = row,
    style = 'minimal',
    border = 'rounded',
    title = title,
    title_pos = 'center',
  }
  if win then pcall(vim.api.nvim_win_close, win, true) end
  win = vim.api.nvim_open_win(buf, false, opts)

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', { silent = true, noremap = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<esc>', '<cmd>close<CR>', { silent = true, noremap = true })

  local augroup = vim.api.nvim_create_augroup('BreakpointInfoAutoClose', { clear = true })
  local function cleanup()
    pcall(vim.api.nvim_win_close, win, true)
    vim.api.nvim_del_augroup_by_id(augroup)
  end
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = augroup,
    callback = cleanup,
    once = true,
  })
  vim.api.nvim_create_autocmd('BufLeave', {
    buffer = buf,
    group = augroup,
    callback = cleanup,
    once = true,
  })
end

return M
