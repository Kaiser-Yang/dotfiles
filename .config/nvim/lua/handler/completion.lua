local M = {}

function M.next_completion_item()
  return require('blink.cmp').select_next()
end
function M.previous_completion_item()
  return require('blink.cmp').select_prev()
end
function M.accept_completion_item()
  return require('blink.cmp').accept()
end
function M.cancel_completion()
  return require('blink.cmp').cancel()
end
function M.show_completion()
  return require('blink.cmp').show()
end
function M.show_completion_wrap(opts)
  return function() require('blink.cmp').show(opts) end
end
function M.hide_completion()
  return require('blink.cmp').hide()
end
function M.snippet_forward()
  return require('blink.cmp').snippet_forward()
end
function M.snippet_backward()
  return require('blink.cmp').snippet_backward()
end
function M.toggle_signature()
  return require('blink.cmp').show_signature() or require('blink.cmp').hide_signature()
end
function M.scroll_documentation_up()
  return require('blink.cmp').scroll_documentation_up()
end
function M.scroll_documentation_down()
  return require('blink.cmp').scroll_documentation_down()
end
function M.scroll_signature_up()
  return require('blink.cmp').scroll_signature_up()
end
function M.scroll_signature_down()
  return require('blink.cmp').scroll_signature_down()
end

return M
