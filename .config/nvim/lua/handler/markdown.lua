local M = {}

local function expand(input)
  vim.schedule_wrap(vim.snippet.expand)(input)
  return true
end
local function expand_wrap(input)
  return function() return expand(input) end
end
--- @param n integer
--- @return string
function M.title(n) return string.rep('#', n) .. ' ' end
M.separate_line = '---<cr><cr>'
M.todo = '- [ ] '
function M.math_inline()
  local char = '\\$'
  if vim.fn.getcwd():find('github%.io') then char = '\\$\\$' end
  return expand(char .. ' ${1:formula} ' .. char .. '$0')
end
M.link = expand_wrap('[$1](${2:url}) $0')
M.bold = expand_wrap('**${1:bold}** $0')
M.delete_line = expand_wrap('~~${1:delete}~~ $0')
M.italic = expand_wrap('*${1:italic}* $0')
M.math_block = expand_wrap('\\$\\$\n${1:formula}\n\\$\\$\n\n$0')
M.code_block = expand_wrap('```$1\n${2:code}\n```\n\n$0')
M.code_inline = expand_wrap('`${1:code}` $0')
M.image = expand_wrap('![$1](${2:path}) $0')
M.bold_and_italic = expand_wrap('***${1:bold and italic}*** $0')

return M
