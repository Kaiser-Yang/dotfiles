local u = require('utils')
local M = {}

local pattern = '<++>'
local prefix = '<c-g>u<bs>'
-- stylua: ignore start
--- @param n integer
--- @return string
function M.markdown_title(n) return prefix .. string.rep('#', n) .. ' ' end
M.markdown_separate_line = prefix .. '---<cr><cr>'
M.markdown_math_inline = prefix .. '$  $' .. pattern .. string.rep('<c-g>U<left>', 2 + #pattern)
M.markdown_math_inline_2 = prefix .. '$$  $$' .. pattern .. string.rep('<c-g>U<left>', 3 + #pattern)
M.markdown_code_inline = prefix .. '``' .. pattern .. string.rep('<c-g>U<left>', 1 + #pattern)
M.markdown_todo = prefix .. '- [ ] '
M.markdown_link = prefix .. '[](' .. pattern .. ')' .. pattern .. string.rep('<c-g>U<left>', 3 + 2 * #pattern)
M.markdown_bold = prefix .. '****' .. pattern .. string.rep('<c-g>U<left>', 2 + #pattern)
M.markdown_delete_line = prefix .. '~~~~' .. pattern .. string.rep('<c-g>U<left>', 2 + #pattern)
M.markdown_italic = prefix .. '**' .. pattern .. string.rep('<c-g>U<left>', 1 + #pattern)
M.markdown_math_block = prefix .. '$$<cr><cr>$$<cr><cr>' .. pattern .. string.rep('<up>', 3) .. string.rep('<right>', 2)
M.markdown_code_block = prefix .. '```<cr>```<cr><cr>' .. pattern .. string.rep('<up>', 3)
-- stylua: ignore end

function M.markdown_goto_placeholder()
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
        u.key.feedkeys(string.rep('<del>', #pattern), 'n')
      end)
      return prefix
    end
  else
    return false
  end
end

return M
