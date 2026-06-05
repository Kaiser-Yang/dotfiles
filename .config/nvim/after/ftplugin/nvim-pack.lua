local h = require('handler')
local mapping = {
  { { 'n', 'x' }, '[[', h.repmove.previous_plugin, { desc = 'Plugin' } },
  { { 'n', 'x' }, ']]', h.repmove.next_plugin, { desc = 'Plugin' } },
  { 'n', 'q', '<c-w>q', { desc = 'Quit' } },
}
for _, m in ipairs(mapping) do
  m[4].buf = 0
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.keymap.set(unpack(m))
end
