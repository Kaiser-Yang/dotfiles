local u = require('utils')
local M = {}

-- BUG:
-- https://github.com/saghen/blink.indent/issues/45
function M.inside_indent()
  require('blink.indent.motion').textobject()()
  return true
end

function M.around_indent()
  local maps = require('blink.indent.config').mappings
  require('blink.indent.motion').textobject({ border = maps.border })()
  return true
end

function M.toggle_indent_line()
  local indent = require('blink.indent')
  local status = indent.is_enabled() == false
  u.toggle_notify('Indent Line', status, { title = 'Blink Indent' })
  indent.enable(status)
  return true
end
return M
