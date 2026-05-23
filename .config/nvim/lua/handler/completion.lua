local M = {}

function M.select_next()
  if not _G.loaded['blink.cmp'] then return false end
  return require('blink.cmp').select_next()
end
function M.select_previous()
  if not _G.loaded['blink.cmp'] then return false end
  return require('blink.cmp').select_prev()
end
function M.accept()
  if not _G.loaded['blink.cmp'] then return false end
  return require('blink.cmp').accept()
end
function M.cancel()
  if not _G.loaded['blink.cmp'] then return false end
  return require('blink.cmp').cancel()
end
function M.show()
  if not _G.loaded['blink.cmp'] then return false end
  return require('blink.cmp').show()
end
function M.hide()
  if not _G.loaded['blink.cmp'] then return false end
  return require('blink.cmp').hide()
end
function M.snippet_forward()
  if not _G.loaded['blink.cmp'] then return false end
  return require('blink.cmp').snippet_forward()
end
function M.snippet_backward()
  if not _G.loaded['blink.cmp'] then return false end
  return require('blink.cmp').snippet_backward()
end
function M.toggle_signature()
  if not _G.loaded['blink.cmp'] then return false end
  return require('blink.cmp').show_signature() or require('blink.cmp').hide_signature()
end
function M.scroll_documentation_up()
  if not _G.loaded['blink.cmp'] then return false end
  return require('blink.cmp').scroll_documentation_up()
end
function M.scroll_documentation_down()
  if not _G.loaded['blink.cmp'] then return false end
  return require('blink.cmp').scroll_documentation_down()
end
function M.scroll_signature_up()
  if not _G.loaded['blink.cmp'] then return false end
  return require('blink.cmp').scroll_signature_up()
end
function M.scroll_signature_down()
  if not _G.loaded['blink.cmp'] then return false end
  return require('blink.cmp').scroll_signature_down()
end

return M
