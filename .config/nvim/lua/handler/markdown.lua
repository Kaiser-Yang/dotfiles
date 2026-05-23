local u = require('utils')
local M = {}

local pattern = '<++>'
local prefix = '<c-g>u<bs>'
--- @param n integer
--- @return string
function M.title(n) return prefix .. string.rep('#', n) .. ' ' end
M.separate_line = prefix .. '---<cr><cr>'
M.math_inline = function()
  local char = '$'
  if vim.fn.getcwd():find('github%.io') then char = '$$' end
  return prefix .. char .. '  ' .. char .. pattern .. string.rep('<c-g>U<left>', #char + #pattern + 1)
end
M.code_inline = prefix .. '``' .. pattern .. string.rep('<c-g>U<left>', 1 + #pattern)
M.todo = prefix .. '- [ ] '
M.link = prefix .. '[](' .. pattern .. ')' .. pattern .. string.rep('<c-g>U<left>', 3 + 2 * #pattern)
M.bold = prefix .. '****' .. pattern .. string.rep('<c-g>U<left>', 2 + #pattern)
M.delete_line = prefix .. '~~~~' .. pattern .. string.rep('<c-g>U<left>', 2 + #pattern)
M.italic = prefix .. '**' .. pattern .. string.rep('<c-g>U<left>', 1 + #pattern)
M.math_block = prefix .. '$$<cr><cr>$$<cr><cr>' .. pattern .. string.rep('<up>', 3) .. string.rep('<right>', 2)
M.code_block = prefix .. '```<cr>```<cr><cr>' .. pattern .. string.rep('<up>', 3)

function M.goto_placeholder()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local cur_buf = vim.api.nvim_get_current_buf()
  local row_end = math.min(row + 100, vim.api.nvim_buf_line_count(cur_buf))
  local match = vim.fn.matchbufline(cur_buf, pattern, row, row_end)[1]
  if match then
    if match.lnum == row then
      return prefix
        .. string.rep('<c-g>U<right>', #vim.api.nvim_get_current_line():sub(col + 1, match.byteidx))
        .. string.rep('<del>', #pattern)
    else
      vim.schedule(function()
        vim.api.nvim_win_set_cursor(0, { match.lnum, match.byteidx })
        u.key.feed(string.rep('<del>', #pattern), 'n')
      end)
      return prefix
    end
  else
    return false
  end
end

return M
