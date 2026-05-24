local u = require('utils')
local M = {}

M.stage = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  if vim.fn.mode('1') ~= 'n' then
    require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
  else
    require('gitsigns').stage_hunk()
  end
  return true
end

M.undo_stage_hunk = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  require('gitsigns').undo_stage_hunk()
  return true
end

M.stage_buffer = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  require('gitsigns').stage_buffer()
  return true
end

M.reset = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  if vim.fn.mode('1') ~= 'n' then
    require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
  else
    require('gitsigns').reset_hunk()
  end
  return true
end

M.reset_buffer_index = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  require('gitsigns').reset_buffer_index()
  return true
end

M.reset_buffer = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  require('gitsigns').reset_buffer()
  return true
end

M.buffer_blame = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  require('gitsigns').blame()
  return true
end

M.line_blame = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  require('gitsigns').blame_line()
  return true
end

M.select_hunk = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  require('gitsigns').select_hunk()
  return true
end

M.qflist_with_input = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  vim.defer_fn(require('handler').completion.show, 10)
  return ':Gitsigns setqflist '
end

M.loclist_with_input = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  vim.defer_fn(require('handler').completion.show, 10)
  return ':Gitsigns setloclist '
end

M.toggle_current_line_blame = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  u.toggle_notify('Current Line Blame', require('gitsigns').toggle_current_line_blame(), { title = 'Git Sign' })
  return true
end

M.toggle_word_diff = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  u.toggle_notify('Word Diff', require('gitsigns').toggle_word_diff(), { title = 'Git Sign' })
  return true
end

M.toggle_signs = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  u.toggle_notify('Signs', require('gitsigns').toggle_signs(), { title = 'Git Sign' })
  return true
end

M.toggle_numhl = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  u.toggle_notify('Line Number Highlight', require('gitsigns').toggle_numhl(), { title = 'Git Sign' })
  return true
end

M.toggle_linehl = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  u.toggle_notify('Line Highlight', require('gitsigns').toggle_linehl(), { title = 'Git Sign' })
  return true
end

M.toggle_deleted = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  u.toggle_notify('Deleted', require('gitsigns').toggle_deleted(), { title = 'Git Sign' })
  return true
end

M.preview_hunk = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  require('gitsigns').preview_hunk()
  return true
end

M.preview_hunk_inline = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  require('gitsigns').preview_hunk_inline()
  return true
end

M.diff_this_with_input = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  vim.defer_fn(require('handler').completion.show, 10)
  return ':Gitsigns diffthis '
end

return M
