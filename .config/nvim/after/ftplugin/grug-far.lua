vim.schedule(function()
  local h = require('handler')
  local mappings = {
    { 'n', 'g?', h.grug_far.help, { desc = 'Help' } },
    { 'n', '<f1>', h.grug_far.help, { desc = 'Help' } },
    { 'i', '<f1>', h.grug_far.help, { desc = 'Help' } },
    { 'n', '[c', h.repmove.grug_apply_then_previous, { desc = 'Change after Apply' } },
    { 'n', ']c', h.repmove.grug_apply_then_next, { desc = 'Change after Apply' } },
    { 'n', '[C', h.repmove.grug_sync_then_previous, { desc = 'Change after Sync' } },
    { 'n', ']C', h.repmove.grug_sync_then_next, { desc = 'Change after Sync' } },
    { 'n', '[[', h.repmove.grug_open_previous, { desc = 'Location Then Open' } },
    { 'n', ']]', h.repmove.grug_open_next, { desc = 'Location Then Open' } },
  }
  for _, m in ipairs(mappings) do
    m[4].buf = 0
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.keymap.set(unpack(m))
  end
end)
