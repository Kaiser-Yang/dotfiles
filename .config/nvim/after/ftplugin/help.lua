local h = require('lightboat.handler')
local mapping = {
  { { 'n', 'x', 'o' }, '[]', h.previous_section_end, { desc = 'Block End' } },
  { { 'n', 'x', 'o' }, '][', h.next_section_end, { desc = 'Block End' } },
  { { 'n', 'x', 'o' }, '[[', h.previous_section_start, { desc = 'Section Start' } },
  { { 'n', 'x', 'o' }, ']]', h.next_section_start, { desc = 'Section Start' } },
}
for _, m in ipairs(mapping) do
  m[4].buffer = true
  vim.keymap.set(unpack(m))
end
