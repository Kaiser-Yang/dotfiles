local u = require('utils')

local function load_gitsigns()
  require('gitsigns').setup({
    attach_to_untracked = true,
    current_line_blame = true,
    current_line_blame_opts = { delay = 300 },
    preview_config = { border = vim.o.winborder or nil },
    on_attach = function(buffer)
      local g = require('gitsigns')
      local h = require('handler')
      local mapping = {
        { { 'n', 'x' }, '[g', h.previous_hunk, { desc = 'Git Hunk' } },
        { { 'n', 'x' }, ']g', h.next_hunk, { desc = 'Git Hunk' } },
        { { 'x', 'o' }, 'ah', g.select_hunk, { desc = 'Git Hunk' } },
        { { 'x', 'o' }, 'ih', g.select_hunk, { desc = 'Git Hunk' } },
        { 'x', '<leader>ga', h.stage_selection, { desc = 'Add' } },
        { 'x', '<leader>gr', h.reset_selection, { desc = 'Reset' } },
        { 'n', '<leader>ga', g.stage_hunk, { desc = 'Add Hunk' } },
        { 'n', '<leader>gA', g.stage_buffer, { desc = 'Add Buffer' } },
        { 'n', '<leader>gu', g.undo_stage_hunk, { desc = 'Undo Add Hunk' } },
        { 'n', '<leader>gU', g.reset_buffer_index, { desc = 'Undo Add Buffer' } },
        { 'n', '<leader>gr', g.reset_hunk, { desc = 'Reset Hunk' } },
        { 'n', '<leader>gR', g.reset_buffer, { desc = 'Reset Buffer' } },
        { 'n', '<leader>gd', g.preview_hunk, { desc = 'Diff' } },
        { 'n', '<leader>gD', g.preview_hunk_inline, { desc = 'Diff Inline' } },
        { 'n', '<leader>gt', h.diff_this, { desc = 'Diff This' } },
        { 'n', '<leader>gb', g.blame_line, { desc = 'Blame Line' } },
        { 'n', '<leader>gq', h.quickfix_all_hunk, { desc = 'Quickfix All Hunk' } },
        { 'n', '<leader>tgb', h.toggle_current_line_blame, { desc = 'Blame' } },
        { 'n', '<leader>tgw', h.toggle_word_diff, { desc = 'Word Diff' } },
        { 'n', '<leader>tgs', h.toggle_signs, { desc = 'Sign' } },
        { 'n', '<leader>tgn', h.toggle_numhl, { desc = 'Line Number Highlight' } },
        { 'n', '<leader>tgl', h.toggle_linehl, { desc = 'Line Highlight' } },
        { 'n', '<leader>tgd', h.toggle_deleted, { desc = 'Deleted' } },
      }
      for _, m in ipairs(mapping) do
        m[4].buffer = buffer
        vim.keymap.set(unpack(m))
      end
    end,
  })
end

local function load_resolve()
  -- TODO: when will this be merged?
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
  require('resolve').setup({
    default_keymaps = false,
    auto_detect_enabled = false,
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
  })
end

load_gitsigns()
load_resolve()
