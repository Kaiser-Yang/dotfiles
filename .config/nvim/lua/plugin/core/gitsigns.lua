local u = require('utils')
u.gh('lewis6991/gitsigns.nvim')

require('gitsigns').setup({
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = { delay = 300 },
  preview_config = { border = vim.o.winborder or nil },
  on_attach = function(buffer)
    local g = require('gitsigns')
    local h = require('handler')
    local mapping = {
      { { 'n', 'x' }, '[g', h.repmove.previous_hunk, { desc = 'Git Hunk' } },
      { { 'n', 'x' }, ']g', h.repmove.next_hunk, { desc = 'Git Hunk' } },
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
      { 'n', '<leader>gq', g.setqflist, { desc = 'Hunk Quickfix This File' } },
      { 'n', '<leader>gQ', function() g.setqflist('all') end, { desc = 'Hunk Quickfix All Files' } },
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
