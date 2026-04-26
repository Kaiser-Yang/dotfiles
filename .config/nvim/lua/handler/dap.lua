local M = {}

function M.toggle_dap_view()
  require('dap-view').toggle()
  return true
end

function M.restart_or_run_last()
  local dap = require('dap')
  if dap.session() then
    dap.restart()
  else
    dap.run_last()
  end
  return true
end

M.set_condition_breakpoint = function()
  vim.ui.input({ prompt = 'Condition Breakpoint' }, function(input)
    if input and input ~= '' then require('dap').set_breakpoint(input) end
  end)
  return true
end

M.set_log_point = function()
  vim.ui.input({ prompt = 'Log Point Message' }, function(input)
    if input and input ~= '' then require('dap').set_breakpoint(nil, nil, input) end
  end)
  return true
end

return M
