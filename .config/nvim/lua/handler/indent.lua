local u = require('utils')
local M = {}

-- BUG:
-- https://github.com/saghen/blink.indent/issues/45
function M.inside()
  if not _G.loaded['blink.indent'] then return false end
  require('blink.indent.motion').textobject()()
  return true
end

function M.around()
  if not _G.loaded['blink.indent'] then return false end
  local maps = require('blink.indent.config').mappings
  require('blink.indent.motion').textobject({ border = maps.border })()
  return true
end

function M.toggle()
  if not _G.loaded['blink.indent'] then return false end
  local indent = require('blink.indent')
  local status = indent.is_enabled() == false
  u.toggle_notify('Indent Line', status, { title = 'Blink Indent' })
  indent.enable(status)
  return true
end

return M
