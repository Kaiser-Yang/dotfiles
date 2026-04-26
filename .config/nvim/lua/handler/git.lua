local u = require('utils')
local M = {}
M._previous_conflict = function()
  require('resolve').prev_conflict()
  return true
end
M._next_conflict = function()
  require('resolve').next_conflict()
  return true
end
M._previous_hunk = function()
  require('gitsigns').nav_hunk('prev')
  return true
end
M._next_hunk = function()
  require('gitsigns').nav_hunk('next')
  return true
end

M.stage_selection = function()
  require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
  return true
end
M.reset_selection = function()
  require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
  return true
end
M.quickfix_all_hunk = function()
  require('gitsigns').setqflist('all')
  return true
end
M.toggle_current_line_blame = function()
  u.toggle_notify('Current Line Blame', require('gitsigns').toggle_current_line_blame(), { title = 'Git Sign' })
  return true
end
M.toggle_word_diff = function()
  u.toggle_notify('Word Diff', require('gitsigns').toggle_word_diff(), { title = 'Git Sign' })
  return true
end
M.toggle_signs = function()
  u.toggle_notify('Signs', require('gitsigns').toggle_signs(), { title = 'Git Sign' })
  return true
end
M.toggle_numhl = function()
  u.toggle_notify('Line Number Highlight', require('gitsigns').toggle_numhl(), { title = 'Git Sign' })
  return true
end
M.toggle_linehl = function()
  u.toggle_notify('Line Highlight', require('gitsigns').toggle_linehl(), { title = 'Git Sign' })
  return true
end
M.toggle_deleted = function()
  u.toggle_notify('Deleted', require('gitsigns').toggle_deleted(), { title = 'Git Sign' })
  return true
end
M.diff_this = function()
  require('gitsigns').diffthis('~')
  return true
end
return M
