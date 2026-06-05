local u = require('utils')
local h = require('handler')
local function comma_typed()
  local key = u.key.last_key()
  return key and key:match(',$') ~= nil
end
local mappings = {
  { 'i', '1', h.markdown.title(1), { desc = 'Insert Markdown Title 1' } },
  { 'i', '2', h.markdown.title(2), { desc = 'Insert Markdown Title 2' } },
  { 'i', '3', h.markdown.title(3), { desc = 'Insert Markdown Title 3' } },
  { 'i', '4', h.markdown.title(4), { desc = 'Insert Markdown Title 4' } },
  { 'i', '5', h.markdown.title(5), { desc = 'Insert Markdown Title 5' } },
  { 'i', '6', h.markdown.title(6), { desc = 'Insert Markdown Title 6' } },
  { 'i', 's', h.markdown.separate_line, { desc = 'Insert Markdown Separate Line' } },
  { 'i', 'a', h.markdown.link, { desc = 'Insert Markdown Link' } },
  { 'i', 'b', h.markdown.bold, { desc = 'Insert Markdown Bold Text' } },
  { 'i', 'B', h.markdown.bold_and_italic, { desc = 'Insert Markdown Bold and Italic Text' } },
  { 'i', 'c', h.markdown.code_block, { desc = 'Insert Markdown Code Block' } },
  { 'i', 'd', h.markdown.delete_line, { desc = 'Insert Markdown Delete Line' } },
  { 'i', 'i', h.markdown.italic, { desc = 'Insert Markdown Italic Text' } },
  { 'i', 'm', h.markdown.math_inline, { desc = 'Insert Markdown Inline Math' } },
  { 'i', 'M', h.markdown.math_block, { desc = 'Insert Markdown Math Block' } },
  { 'i', 'p', h.markdown.image, { desc = 'Insert Markdown Image' } },
  { 'i', 't', h.markdown.code_inline, { desc = 'Insert Markdown Code Line' } },
  { 'i', 'x', h.markdown.todo, { desc = 'Insert Markdown Todo' } },
}
for _, m in ipairs(mappings) do
  local rhs = m[3]
  ---@diagnostic disable-next-line: assign-type-mismatch
  m[3] = function()
    local res = m[2]
    if not comma_typed() then return res end
    local prefix = ''
    if type(rhs) == 'function' then
      res = rhs()
      if not res then
        res = m[2]
      else
        if res == true then res = '' end
        prefix = '<c-g>u<bs>'
      end
    else
      res = rhs
      prefix = '<c-g>u<bs>'
    end
    return prefix .. res
  end
  m[4].expr = true
  m[4].buf = 0
  vim.keymap.set(unpack(m))
end
