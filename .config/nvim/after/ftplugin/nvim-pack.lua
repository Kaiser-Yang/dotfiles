vim.schedule(function()
  local h = require('handler')
  local mapping = {
    { { 'n', 'x' }, '[[', h.previous_plugin, { desc = 'Plugin' } },
    { { 'n', 'x' }, ']]', h.next_plugin, { desc = 'Plugin' } },
  }
  for _, m in ipairs(mapping) do
    m[4].buffer = true
    vim.keymap.set(unpack(m))
  end
end)
