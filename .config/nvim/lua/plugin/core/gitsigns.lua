local u = require('utils')
u.gh('lewis6991/gitsigns.nvim')

require('gitsigns').setup({
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = { delay = 300 },
  preview_config = { border = vim.o.winborder or nil },
  on_attach = function(buffer)
    local h = require('handler')
    local mapping = {
      { { 'n', 'x' }, '[g', h.repmove.previous_hunk, { desc = 'Git Hunk' } },
      { { 'n', 'x' }, ']g', h.repmove.next_hunk, { desc = 'Git Hunk' } },
      { { 'o', 'x' }, 'ah', h.git.select_hunk, { desc = 'Git Hunk' } },
      { { 'o', 'x' }, 'ih', h.git.select_hunk, { desc = 'Git Hunk' } },
      { { 'n', 'x' }, '<leader>ga', h.git.stage, { desc = 'Add' } },
      { 'n', '<leader>gA', h.git.stage_buffer, { desc = 'Add Buffer' } },
      { 'n', '<leader>gu', h.git.undo_stage_hunk, { desc = 'Undo Add Hunk' } },
      { 'n', '<leader>gU', h.git.reset_buffer_index, { desc = 'Undo Add Buffer' } },
      { { 'n', 'x' }, '<leader>gr', h.git.reset, { desc = 'Reset' } },
      { 'n', '<leader>gR', h.git.reset_buffer, { desc = 'Reset Buffer' } },
      { 'n', '<leader>gt', h.git.diff_this, { desc = 'Diff This' } },
      { 'n', '<leader>gT', h.git.diff_this_with_input, { expr = true, desc = 'Diff This with input' } },
      { 'n', '<leader>gd', h.git.preview_hunk, { desc = 'Diff' } },
      { 'n', '<leader>gD', h.git.preview_hunk_inline, { desc = 'Diff Inline' } },
      { 'n', '<leader>gq', h.git.quickfix_all_hunk, { desc = 'All to Quickfix' } },
      { 'n', '<leader>gQ', h.git.quickfix_with_input, { expr = true, desc = 'Quickfix With Input' } },
      { 'n', '<leader>gb', h.git.line_blame, { desc = 'Current Line Blame' } },
      { 'n', '<leader>gB', h.git.buffer_blame, { desc = 'Current Buffer Blame' } },
      { 'n', '<leader>tgb', h.git.toggle_current_line_blame, { desc = 'Blame' } },
      { 'n', '<leader>tgw', h.git.toggle_word_diff, { desc = 'Word Diff' } },
      { 'n', '<leader>tgs', h.git.toggle_signs, { desc = 'Sign' } },
      { 'n', '<leader>tgn', h.git.toggle_numhl, { desc = 'Line Number Highlight' } },
      { 'n', '<leader>tgl', h.git.toggle_linehl, { desc = 'Line Highlight' } },
      { 'n', '<leader>tgd', h.git.toggle_deleted, { desc = 'Deleted' } },
    }
    for _, m in ipairs(mapping) do
      m[4].buffer = buffer
      vim.keymap.set(unpack(m))
    end
  end,
})
