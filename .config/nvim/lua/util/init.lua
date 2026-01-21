local M = {
  key = require('util.key'),
}

function M.get(opt, ...)
  if type(opt) == 'function' then
    return opt(...)
  else
    return opt
  end
end

return M
