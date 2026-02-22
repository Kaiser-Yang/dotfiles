local mapping = {
  { 'n', '[x' },
  { 'n', ']x' },
  { 'n', '<leader>xc' },
  { 'n', '<leader>xi' },
  { 'n', '<leader>xb' },
  { 'n', '<leader>xB' },
  { 'n', '<leader>xn' },
  { 'n', '<leader>xa' },
}
if vim.fn.executable('delta') == 1 then
  mapping = vim.list_extend(mapping, {
    { 'n', '<leader>xdi' },
    { 'n', '<leader>xdc' },
    { 'n', '<leader>xdb' },
    { 'n', '<leader>xdv' },
    { 'n', '<leader>xdV' },
  })
end
return {
  'Kaiser-Yang/resolve.nvim',
  opts = {
    on_conflict_detected = function(args)
      local h = require('lightboat.handler')
      local r = require('resolve')
      if #mapping[1] < 4 then
        vim.list_extend(mapping[1], { h.previous_conflict, { desc = 'Previous Conflict' } })
        vim.list_extend(mapping[2], { h.next_conflict, { desc = 'Next Conflict' } })
        vim.list_extend(mapping[3], { r.choose_ours, { desc = 'Choose Current' } })
        vim.list_extend(mapping[4], { r.choose_theirs, { desc = 'Choose Incoming' } })
        vim.list_extend(mapping[5], { r.choose_both, { desc = 'Choose Both' } })
        vim.list_extend(mapping[6], { r.choose_both_reverse, { desc = 'Choose Both Reverse' } })
        vim.list_extend(mapping[7], { r.choose_none, { desc = 'Choose None' } })
        vim.list_extend(mapping[8], { r.choose_base, { desc = 'Choose Ancestor' } })
        if vim.fn.executable('delta') == 1 then
          vim.list_extend(mapping[9], { r.show_diff_theirs, { desc = 'Incoming' } })
          vim.list_extend(mapping[10], { r.show_diff_ours, { desc = 'Current' } })
          vim.list_extend(mapping[11], { r.show_diff_both, { desc = 'Both' } })
          vim.list_extend(mapping[12], { r.show_diff_ours_vs_theirs, { desc = 'Current V.S. Incoming' } })
          vim.list_extend(mapping[13], { r.show_diff_theirs_vs_ours, { desc = 'Incoming V.S. Current' } })
        end
      end
      for _, m in ipairs(mapping) do
        m[4].buffer = args.bufnr
        vim.keymap.set(unpack(m))
      end
      vim.diagnostic.enable(false, { bufnr = args.bufnr })
    end,
    on_conflicts_resolved = function(args)
      vim.diagnostic.enable(true, { bufnr = args.bufnr })
      for _, m in ipairs(mapping) do
        pcall(vim.keymap.del, m[1], m[2], { buffer = args.bufnr })
      end
    end,
  },
  config = function(_, opts)
    require('resolve').setup(opts)
    if require('lightboat.util').git.is_git_repository() then
      vim.cmd('DetectConflictAndLoad')
    end
  end,
}
