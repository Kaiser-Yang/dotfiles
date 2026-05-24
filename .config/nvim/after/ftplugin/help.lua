vim.schedule(function()
  local h = require('handler')
  local mapping = {
    { { 'n', 'x', 'o' }, '[[', h.repmove.previous_section_start, { desc = 'Section Start' } },
    { { 'n', 'x', 'o' }, ']]', h.repmove.next_section_start, { desc = 'Section Start' } },
  }
  for _, m in ipairs(mapping) do
    m[4].buffer = true
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.keymap.set(unpack(m))
  end
end)
vim.cmd('setlocal number relativenumber')
