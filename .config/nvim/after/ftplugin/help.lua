vim.cmd('setlocal number relativenumber')
local h = require('handler')
local mapping = {
  { { 'n', 'x', 'o' }, '[[', h.repmove.previous_section_start, { desc = 'Section Start' } },
  { { 'n', 'x', 'o' }, ']]', h.repmove.next_section_start, { desc = 'Section Start' } },
  { 'n', 'q', h.builtin.window('q'), { desc = 'Quit' } },
}
for _, m in ipairs(mapping) do
  m[4].buf = 0
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.keymap.set(unpack(m))
end
