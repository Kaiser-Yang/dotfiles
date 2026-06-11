local u = require('utils')
u.gh('Kaiser-Yang/maplayer.nvim')

-- We have provide another key binding for commenting current line
-- We must remove this to make "gc" work
vim.api.nvim_del_keymap('n', 'gcc')
local h = require('handler')
local opts = {
  -- Builtin
  { key = 'J', desc = 'Join', handler = h.builtin.join },
  { key = 'j', mode = 'nx', desc = 'Record Jump List', handler = h.builtin.jump_list_wrap('j') },
  { key = 'k', mode = 'nx', desc = 'Record Jump List', handler = h.builtin.jump_list_wrap('k') },
  { key = '<c-f>', mode = 'ci', desc = 'Right', handler = h.builtin.right },
  { key = '<c-b>', mode = 'ci', desc = 'Left', handler = h.builtin.left },
  { key = '<m-f>', mode = 'ci', desc = 'Word Forward', handler = h.builtin.word_forward },
  { key = '<m-b>', mode = 'ci', desc = 'Word Backward', handler = h.builtin.word_backward },
  { key = '<c-p>', mode = 'ci', desc = 'Nop', handler = h.builtin.nop },
  { key = '<c-n>', mode = 'ci', desc = 'Nop', handler = h.builtin.nop },
  { key = '<tab>', mode = 'c', desc = 'Nop', handler = h.builtin.nop },
  { key = '<s-tab>', mode = 'c', desc = 'Nop', handler = h.builtin.nop },
  { key = '<cr>', mode = 'i', desc = 'Insert Undo Point', handler = h.builtin.insert_undo_point, priority = 1 },
  { key = '<m-x>', mode = 'nox', desc = 'System Cut', handler = h.builtin.system_cut, expr = true },
  { key = '<m-c>', mode = 'nox', desc = 'System Yank', handler = h.builtin.system_yank, expr = true },
  { key = '<m-v>', mode = 'cinx', desc = 'System Put', handler = h.builtin.system_put, expr = true },
  { key = '<m-X>', desc = 'System Cut EOL', handler = h.builtin.system_cut_eol },
  { key = '<m-C>', desc = 'System Yank EOL', handler = h.builtin.system_yank_eol },
  { key = '<m-V>', mode = 'nx', desc = 'System Put Before', handler = h.builtin.system_put_before },
  { key = '<m-d>', mode = 'ci', desc = 'Delete EOW', handler = h.builtin.delete_to_eow },
  { key = '<m-g>', mode = 'nt', desc = 'Toggle Lazygit', handler = h.builtin.toggle_lazygit },
  { key = '<m-/>', mode = 'inx', desc = 'Toggle Comment', handler = h.builtin.toggle_comment },
  { key = '<c-h>', desc = 'Left', handler = h.builtin.window('h') },
  { key = '<c-j>', desc = 'Bottom', handler = h.builtin.window('j') },
  { key = '<c-k>', desc = 'Top', handler = h.builtin.window('k') },
  { key = '<c-l>', desc = 'Right', handler = h.builtin.window('l') },
  { key = '<c-w>h', desc = 'Swap Left', handler = h.builtin.swap_wrap('left') },
  { key = '<c-w>j', desc = 'Swap Bottom', handler = h.builtin.swap_wrap('bottom') },
  { key = '<c-w>k', desc = 'Swap Top', handler = h.builtin.swap_wrap('top') },
  { key = '<c-w>l', desc = 'Swap Right', handler = h.builtin.swap_wrap('right') },
  { key = { '<c-w>t', '<c-w><c-t>' }, desc = 'Tab Split', handler = h.builtin.tab_split },
  -- INFO:
  -- By default "<C-A>" is used to insert all commands in command mode
  -- and is used to insert previously inserted text in insert mode
  { key = '<c-a>', mode = 'ci', desc = 'Cursor BOL', handler = h.builtin.cursor_to_bol },
  -- INFO:
  -- By default, "<c-e>" is used to insert content below the cursor
  -- This hack will make it still work as default when the cursor is already at the end of the line in insert mode
  { key = '<c-e>', mode = 'ci', desc = 'Cursor EOL', handler = h.builtin.cursor_to_eol, fallback = true, priority = 0 },
  -- INFO:
  -- By default, "<c-k>" is used to insert digraph, see ":help i_CTRL-K" and ":help c_CTRL-K"
  { key = '<c-k>', mode = 'ci', desc = 'Delete EOL', handler = h.builtin.delete_to_eol, fallback = true, priority = 0 },
  { key = '&', desc = 'Last Substitute', handler = h.builtin.last_s_cmd },
  { key = '<m-n>', mode = 'c', desc = 'Next Commend History', handler = h.builtin.down },
  { key = '<m-p>', mode = 'c', desc = 'Previous Commend History', handler = h.builtin.up },
  { key = '<leader>r', desc = 'Run Single File', handler = h.builtin.run_single_file },
  { key = '<leader>td', desc = 'Buffer Diagnostic', handler = h.builtin.toggle_diagnostic },
  { key = '<leader>ts', desc = 'Spell', handler = h.builtin.toggle_spell },
  { key = '<leader>tt', desc = 'Treesitter Highlight', handler = h.builtin.toggle_treesitter },
  { key = '<c-q>', desc = 'Diagnostic Qflist', handler = h.builtin.diagnostic_qflist },
  { key = 'al', mode = 'ox', desc = 'All Line', handler = h.builtin.select_file },
  { key = { '<esc>', '<c-[>' }, desc = 'No Highlight Search', handler = h.builtin.no_hl_search },
  { key = 'aa', mode = 'ox', desc = '<> Block', handler = h.builtin.around_angle_bracket, expr = true },
  { key = 'ia', mode = 'ox', desc = '<> Block', handler = h.builtin.inside_angle_bracket, expr = true },
  { key = 'ar', mode = 'ox', desc = '[] Block', handler = h.builtin.around_square_bracket, expr = true },
  { key = 'ir', mode = 'ox', desc = '[] Block', handler = h.builtin.inside_square_bracket, expr = true },
  { key = 'aq', mode = 'ox', desc = 'Quotation Block', handler = h.builtin.action_wrap('a', { '`', '"', "'" }) },
  { key = 'iq', mode = 'ox', desc = 'Quotation Block', handler = h.builtin.action_wrap('i', { '`', '"', "'" }) },
  { key = 'as', mode = 'ox', desc = 'Surrounding Block', handler = h.builtin.action_wrap('i', { '}', ']', ')', '>' }) },
  { key = 'is', mode = 'ox', desc = 'Surrounding Block', handler = h.builtin.action_wrap('a', { '}', ']', ')', '>' }) },
  { key = 'a~', mode = 'ox', desc = '~~ Block', handler = h.builtin.action_wrap('a', '~') },
  { key = 'i~', mode = 'ox', desc = '~~ Block', handler = h.builtin.action_wrap('i', '~') },
  { key = 'a$', mode = 'ox', desc = '$$ Block', handler = h.builtin.action_wrap('a', '$') },
  { key = 'i$', mode = 'ox', desc = '$$ Block', handler = h.builtin.action_wrap('i', '$') },
  { key = 'a*', mode = 'ox', desc = '** Block', handler = h.builtin.action_wrap('a', '*') },
  { key = 'i*', mode = 'ox', desc = '** Block', handler = h.builtin.action_wrap('i', '*') },
  { key = 'a ', mode = 'ox', desc = 'Space Block', handler = h.builtin.action_wrap('a', ' ') },
  { key = 'i ', mode = 'ox', desc = 'Space Block', handler = h.builtin.action_wrap('i', ' ') },
  { key = 'zS', desc = 'Inspect', handler = h.builtin.inspect },

  -- LSP
  -- INFO:
  -- By default, "tagfunc" is set when "LspAttach",
  -- "<C-]>", "<C-W>]", and "<C-W>}" will work, you can use them to go to definition
  { key = 'K', desc = 'Hover', handler = h.lsp.hover, fallback = true },
  { key = 'grn', desc = 'Rename', handler = h.lsp.rename },
  { key = 'gra', mode = 'nx', desc = 'Code Action', handler = h.lsp.code_action },
  { key = 'grd', desc = 'Declaration', handler = h.lsp.declaration },
  { key = 'grx', desc = 'Code Lens', handler = h.lsp.codelens_run },
  { key = 'grr', mode = 'nx', desc = 'Refactor', handler = h.lsp.refactor },
  { key = 'grR', desc = 'Reference', handler = h.lsp.references },
  { key = 'grI', desc = 'Implementation', handler = h.lsp.implementation },
  { key = 'gri', desc = 'Incoming Call', handler = h.lsp.incoming_calls },
  { key = 'gro', desc = 'Outgoing Call', handler = h.lsp.outgoing_calls },
  { key = 'grt', desc = 'Type Definition', handler = h.lsp.type_definition },
  { key = 'gO', desc = 'Document Symbol', handler = h.lsp.document_symbol },
  { key = 'gW', desc = 'Dynamic Workspace Symbol', handler = h.lsp.dynamic_workspace_symbols },
  { key = '<leader>ti', desc = 'Inlay Hint', handler = h.lsp.toggle_inlay_hint },
  { key = '<leader>tx', desc = 'Code Lens', handler = h.lsp.toggle_codelens },

  -- Git
  { key = { 'ah', 'ih' }, mode = 'ox', desc = 'Git Hunk', handler = h.git.select_hunk },
  { key = '<leader>ga', mode = 'nx', desc = 'Add', handler = h.git.stage },
  { key = '<leader>gA', desc = 'Add Buffer', handler = h.git.stage_buffer },
  { key = '<leader>gu', desc = 'Undo Add', handler = h.git.undo_stage_hunk },
  { key = '<leader>gU', desc = 'Undo Add Buffer', handler = h.git.reset_buffer_index },
  { key = '<leader>gr', mode = 'nx', desc = 'Reset', handler = h.git.reset },
  { key = '<leader>gR', desc = 'Reset Buffer', handler = h.git.reset_buffer },
  { key = '<leader>gt', desc = 'Git Diff This', handler = h.git.diff_this_with_input, expr = true },
  { key = '<leader>gq', desc = 'Qflist', handler = h.git.qflist_with_input, expr = true },
  { key = '<leader>gl', desc = 'Loclist', handler = h.git.loclist_with_input, expr = true },
  { key = '<leader>gd', desc = 'Diff', handler = h.git.preview_hunk },
  { key = '<leader>gD', desc = 'Diff Inline', handler = h.git.preview_hunk_inline },
  { key = '<leader>gb', desc = 'Line Blame', handler = h.git.line_blame },
  { key = '<leader>gB', desc = 'Buffer Blame', handler = h.git.buffer_blame },
  { key = '<leader>xc', desc = 'Current', handler = h.git.choose_ours },
  { key = '<leader>xi', desc = 'Incoming', handler = h.git.choose_theirs },
  { key = '<leader>xb', desc = 'Both', handler = h.git.choose_both },
  { key = '<leader>xB', desc = 'Both Reverse', handler = h.git.choose_both_reverse },
  { key = '<leader>xn', desc = 'None', handler = h.git.choose_none },
  { key = '<leader>xa', desc = 'Ancestor', handler = h.git.choose_base },
  { key = '<leader>xdi', desc = 'Incoming', handler = h.git.show_diff_theirs },
  { key = '<leader>xdc', desc = 'Current', handler = h.git.show_diff_ours },
  { key = '<leader>xdb', desc = 'Both', handler = h.git.show_diff_both },
  { key = '<leader>xdv', desc = 'Current vs. Incoming', handler = h.git.show_diff_ours_vs_theirs },
  { key = '<leader>xdV', desc = 'Incoming vs. Current', handler = h.git.show_diff_theirs_vs_ours },
  { key = '<leader>tgb', desc = 'Current Line Blame', handler = h.git.toggle_current_line_blame },
  { key = '<leader>tgw', desc = 'Word Diff', handler = h.git.toggle_word_diff },
  { key = '<leader>tgs', desc = 'Sign', handler = h.git.toggle_signs },
  { key = '<leader>tgn', desc = 'Line Number Highlight', handler = h.git.toggle_numhl },
  { key = '<leader>tgd', desc = 'Deleted', handler = h.git.toggle_deleted },
  { key = '<leader>tgl', desc = 'Line Highlight', handler = h.git.toggle_linehl },

  -- Repmove Motion
  { key = ';', mode = 'nx', desc = 'Last Motion Forward', handler = h.repmove.semicolon },
  { key = ',', mode = 'nx', desc = 'Last Motion Backward', handler = h.repmove.comma },
  { key = 'f', mode = 'nox', desc = 'Flash f', handler = h.repmove.f },
  { key = 'F', mode = 'nox', desc = 'Flash F', handler = h.repmove.F },
  { key = 't', mode = 'nox', desc = 'Flash t', handler = h.repmove.t },
  { key = 'T', mode = 'nox', desc = 'Flash T', handler = h.repmove.T },
  { key = '%', mode = 'nox', desc = 'Next Matchit', handler = h.repmove.matchit_wrap('%'), expr = true },
  { key = 'g%', mode = 'nox', desc = 'Previous Matchit', handler = h.repmove.matchit_wrap('g%'), expr = true },
  { key = '[%', mode = 'nox', desc = 'Next Multi Matchit', handler = h.repmove.matchit_wrap('[%'), expr = true },
  { key = ']%', mode = 'nox', desc = 'Previous Multi Mathit', handler = h.repmove.matchit_wrap(']%'), expr = true },
  -- INFO:
  -- By default, "[c" and "]c" are used to navigate changes in the buffer.
  -- In most cases, we cant use "[g" and "]g" to navigate between git hunks
  { key = '[c', mode = 'nox', desc = 'Class Start', handler = h.repmove.previous_class_start },
  { key = ']c', mode = 'nox', desc = 'Class Start', handler = h.repmove.next_class_start },
  { key = '[C', mode = 'nox', desc = 'Class End', handler = h.repmove.previous_class_end },
  { key = ']C', mode = 'nox', desc = 'Class End', handler = h.repmove.next_class_end },
  { key = '[d', mode = 'nox', desc = 'Diagnostic', handler = h.repmove.previous_diagnostic },
  { key = ']d', mode = 'nox', desc = 'Diagnostic', handler = h.repmove.next_diagnostic },
  { key = '[D', mode = 'nox', desc = 'First Diagnostic', handler = h.repmove.first_diagnostic },
  { key = ']D', mode = 'nox', desc = 'Last Diagnostic', handler = h.repmove.last_diagnostic },
  { key = '[g', mode = 'nx', desc = 'Git Hunk', handler = h.repmove.previous_hunk },
  { key = ']g', mode = 'nx', desc = 'Git Hunk', handler = h.repmove.next_hunk },
  { key = '[x', mode = 'nx', desc = 'Conflict', handler = h.repmove.previous_conflict },
  { key = ']x', mode = 'nx', desc = 'Conflict', handler = h.repmove.next_conflict },
  -- INFO:
  -- By default, "[i", "]i", "[I", and "]I" are used to show information of keywords under cursor
  { key = '[i', mode = 'nox', desc = 'If Start', handler = h.repmove.previous_conditional_start },
  { key = ']i', mode = 'nox', desc = 'If Start', handler = h.repmove.next_conditional_start },
  { key = '[I', mode = 'nox', desc = 'If End', handler = h.repmove.previous_conditional_end },
  { key = ']I', mode = 'nox', desc = 'If End', handler = h.repmove.next_conditional_end },
  -- INFO:
  -- By default "[f" and "]f" are aliases of "gf"
  { key = '[f', mode = 'nox', desc = 'For Start', handler = h.repmove.previous_loop_start },
  { key = ']f', mode = 'nox', desc = 'For Start', handler = h.repmove.next_loop_start },
  { key = '[F', mode = 'nox', desc = 'For End', handler = h.repmove.previous_loop_end },
  { key = ']F', mode = 'nox', desc = 'For End', handler = h.repmove.next_loop_end },
  { key = '[m', mode = 'nox', desc = 'Method Start', handler = h.repmove.previous_function_start },
  { key = ']m', mode = 'nox', desc = 'Method Start', handler = h.repmove.next_function_start },
  { key = '[M', mode = 'nox', desc = 'Method End', handler = h.repmove.previous_function_end },
  { key = ']M', mode = 'nox', desc = 'Method End', handler = h.repmove.next_function_end },
  { key = '[s', mode = 'nox', desc = 'Misspelled Word', handler = h.repmove.previous_misspelled },
  { key = ']s', mode = 'nox', desc = 'Misspelled Word', handler = h.repmove.next_misspelled },
  -- INFO:
  -- By default "[t" and "]t" are mapped to ":tp" and ":tn"
  { key = '[t', mode = 'nox', desc = 'Todo', handler = h.repmove.previous_todo },
  { key = ']t', mode = 'nox', desc = 'Todo', handler = h.repmove.next_todo },
  { key = '[[', mode = 'nox', desc = 'Block Start', handler = h.repmove.previous_block_start },
  { key = ']]', mode = 'nox', desc = 'Block Start', handler = h.repmove.next_block_start },
  { key = '[]', mode = 'nox', desc = 'Block End', handler = h.repmove.previous_block_end },
  { key = '][', mode = 'nox', desc = 'Block End', handler = h.repmove.next_block_end },
  { key = '[a', desc = 'File', handler = h.repmove.previous_file },
  { key = ']a', desc = 'File', handler = h.repmove.next_file },
  { key = '[A', desc = 'File', handler = h.repmove.first_file },
  { key = ']A', desc = 'File', handler = h.repmove.last_file },
  { key = '[b', desc = 'Buffer', handler = h.repmove.previous_buffer },
  { key = ']b', desc = 'Buffer', handler = h.repmove.next_buffer },
  { key = '[B', desc = 'Buffer', handler = h.repmove.first_buffer },
  { key = ']B', desc = 'Buffer', handler = h.repmove.last_buffer },
  { key = '[l', desc = 'Loclist Item', handler = h.repmove.previous_loclist_item },
  { key = ']l', desc = 'Loclist Item', handler = h.repmove.next_loclist_item },
  { key = '[L', desc = 'First Loclist Item', handler = h.repmove.first_loclist_item },
  { key = ']L', desc = 'Last Loclist Item', handler = h.repmove.last_loclist_item },
  { key = '[<c-l>', desc = 'File Loclist Item', handler = h.repmove.previous_file_loclist_item },
  { key = ']<c-l>', desc = 'File Loclist Item', handler = h.repmove.next_file_loclist_item },
  { key = '[n', mode = 'x', desc = 'Select Node', handler = h.repmove.select_previous_node },
  { key = ']n', mode = 'x', desc = 'Select Node', handler = h.repmove.select_next_node },
  { key = '[q', desc = 'Qflist Item', handler = h.repmove.previous_qflist_item },
  { key = ']q', desc = 'Qflist Item', handler = h.repmove.next_qflist_item },
  { key = '[Q', desc = 'First Qflist Item', handler = h.repmove.first_qflist_item },
  { key = ']Q', desc = 'Last Qflist Item', handler = h.repmove.last_qflist_item },
  { key = '[<c-q>', desc = 'File Qflist Item', handler = h.repmove.previous_file_qflist_item },
  { key = ']<c-q>', desc = 'File Qflist Item', handler = h.repmove.next_file_qflist_item },
  { key = 'gT', desc = 'Previous Tab', handler = h.repmove.previous_tab },
  { key = 'gt', desc = 'Select Tab', handler = h.repmove.select_tab },

  -- Tabby
  { key = 'gw', desc = 'Pick Window', handler = h.pick_window },

  -- Flash
  { key = 'r', mode = 'o', desc = 'Flash Remote', handler = h.flash.remote },
  { key = '<c-s>', mode = 'nox', desc = 'Flash Two Char Jump', handler = h.flash.two_char_jump },
  { key = '<leader><leader>', mode = 'nox', desc = 'Flash Jump', handler = h.flash.jump },
  { key = '<leader>w', mode = 'nox', desc = 'Flash Select Word', handler = h.flash.select_word },

  -- Swap
  { key = '<m-s>pa', desc = 'Argument', handler = h.treesitter.swap_with_previous_parameter },
  { key = '<m-s>na', desc = 'Argument', handler = h.treesitter.swap_with_next_parameter },

  -- Treesitter Text Object
  { key = 'ac', mode = 'ox', desc = 'Class', handler = h.treesitter.around_class },
  { key = 'ic', mode = 'ox', desc = 'Class', handler = h.treesitter.inside_class },
  { key = 'af', mode = 'ox', desc = 'For', handler = h.treesitter.around_loop },
  { key = 'if', mode = 'ox', desc = 'For', handler = h.treesitter.inside_loop },
  { key = 'ai', mode = 'ox', desc = 'If', handler = h.treesitter.around_conditional },
  { key = 'ii', mode = 'ox', desc = 'If', handler = h.treesitter.inside_conditional },
  { key = 'am', mode = 'ox', desc = 'Method', handler = h.treesitter.around_function },
  { key = 'im', mode = 'ox', desc = 'Method', handler = h.treesitter.inside_function },

  -- Completion
  { key = '<c-s>', mode = 'is', desc = 'Toggle Signature Help', handler = h.completion.toggle_signature },
  -- INFO:
  -- By default, "<c-u>" are used to delete content before
  {
    key = '<c-u>',
    mode = 'i',
    desc = 'Scroll Documentation Up',
    handler = h.completion.scroll_documentation_up,
    fallback = true,
  },
  {
    key = '<c-u>',
    mode = 'i',
    desc = 'Scroll Signature Up',
    handler = h.completion.scroll_signature_up,
    fallback = true,
  },
  -- INFO:
  -- By default, "<c-d>" and "<c-t>" are used to delete or add indent in insert mode
  {
    key = '<c-d>',
    mode = 'i',
    desc = 'Scroll Documentation Down',
    handler = h.completion.scroll_documentation_down,
    expr = true,
    fallback = true,
  },
  {
    key = '<c-d>',
    mode = 'i',
    desc = 'Scroll Signature Down',
    handler = h.completion.scroll_signature_down,
    expr = true,
    fallback = true,
  },
  {
    key = '<tab>',
    mode = 'ins',
    desc = 'Snippet Forward',
    handler = h.completion.snippet_forward,
    priority = 1,
    fallback = true,
  },
  {
    key = '<s-tab>',
    mode = 'ins',
    desc = 'Snippet Backward',
    handler = h.completion.snippet_backward,
    fallback = true,
  },
  -- INFO:
  -- By default <C-J> is an alias of <CR>
  { key = '<c-j>', mode = 'ci', desc = 'Select Next', handler = h.completion.select_next, fallback = true },
  -- INFO:
  -- By default, "<c-k>" is used to insert digraph, see ":help i_CTRL-K" and ":help c_CTRL-K"
  {
    key = '<c-k>',
    mode = 'ci',
    desc = 'Select Previous',
    handler = h.completion.select_previous,
    fallback = true,
    priority = 1,
  },
  -- INFO:
  -- By default "<c-y>" is used to insert content above the cursor
  { key = '<c-y>', mode = 'ci', desc = 'Accept', handler = h.completion.accept, fallback = true },
  -- INFO:
  -- By default, "<c-e>" is used to insert content below the cursor
  { key = '<c-e>', mode = 'ci', desc = 'Cancel', handler = h.completion.cancel, fallback = true, priority = 1 },

  -- Format
  -- We will format automatically on save, therefore this one is not used frequently.
  -- It will only be useful when the format on save occurs errors such as timeout
  { key = '<m-F>', mode = 'nx', desc = 'Async Format', handler = h.format },

  -- Surround
  -- INFO:
  -- By default "s" and "S" in visual mode are aliases of "c"
  { key = 's', mode = 'x', desc = 'Surround', handler = h.pair.surround_visual, expr = true },
  { key = 'S', mode = 'x', desc = 'Surround Line Mode', handler = h.pair.surround_visual_line, expr = true },
  -- We use this tricky way to make "ys", "cs", "ds", "yS", "cS", "dS", "yss", "ysS", "ySs" and "ySS" work
  -- We do not recommend to update those mappings
  { key = 's', mode = 'o', desc = 'Surround', handler = h.pair.hack_wrap(), expr = true },
  { key = 'S', mode = 'o', desc = 'Surround Line Mode', handler = h.pair.hack_wrap('_line'), expr = true },
  -- Autopair
  { key = '(', mode = 'i', desc = 'Autopair', handler = h.pair.auto_pair_wrap('(') },
  { key = ')', mode = 'i', desc = 'Autopair', handler = h.pair.auto_pair_wrap(')') },
  { key = '[', mode = 'i', desc = 'Autopair', handler = h.pair.auto_pair_wrap('[') },
  { key = ']', mode = 'i', desc = 'Autopair', handler = h.pair.auto_pair_wrap(']') },
  { key = '{', mode = 'i', desc = 'Autopair', handler = h.pair.auto_pair_wrap('{') },
  { key = '}', mode = 'i', desc = 'Autopair', handler = h.pair.auto_pair_wrap('}') },
  { key = '"', mode = 'i', desc = 'Autopair', handler = h.pair.auto_pair_wrap('"') },
  { key = "'", mode = 'i', desc = 'Autopair', handler = h.pair.auto_pair_wrap("'") },
  { key = '`', mode = 'i', desc = 'Autopair', handler = h.pair.auto_pair_wrap('`') },
  { key = '<bs>', mode = 'i', desc = 'Autopair BS', handler = h.pair.auto_pair_wrap('<bs>') },
  { key = '<cr>', mode = 'i', desc = 'Autopair CR', handler = h.pair.auto_pair_wrap('<cr>'), priority = 0 },
  { key = '<space>', mode = 'i', desc = 'Autopair Space', handler = h.pair.auto_pair_wrap('<space>') },
  { key = '<m-e>', mode = 'i', desc = 'Autopair Fastwarp', handler = h.pair.auto_pair_wrap('<m-e>') },
  { key = '<m-E>', mode = 'i', desc = 'Autopair Reverse Fastwarp', handler = h.pair.auto_pair_wrap('<m-E>') },
  { key = '<tab>', mode = 'i', desc = 'Smart Tab', handler = h.pair.smart_tab, priority = 0, fallback = true },

  -- Picker
  { key = 'gy', desc = 'Search Register', handler = h.telescope.registers },
  { key = '<m-r>', desc = 'Resume', handler = h.telescope.resume },
  { key = '<c-f>', desc = 'Live Grep', handler = h.telescope.live_grep },
  { key = '<c-p>', desc = 'Find File', handler = h.telescope.find_file },
  { key = '<m-f>', mode = 'nx', desc = 'Find Word', handler = h.telescope.find_word },
  { key = '<f1>', mode = 'i', desc = 'Search Help', handler = h.telescope.help_tags },
  { key = { '<f1>', 'g?' }, desc = 'Search Help', handler = h.telescope.help_tags },
  { key = '<leader>sa', desc = 'Auto commands', handler = h.telescope.auto_commands },
  { key = '<leader>sd', desc = 'Diagnostics', handler = h.telescope.diagnostics },
  { key = '<leader>sg', desc = 'Git', handler = h.telescope.git_status },
  { key = '<leader>sq', desc = 'Qflist', handler = h.telescope.qflist },
  { key = '<leader>sl', desc = 'Loclist', handler = h.telescope.loclist },
  { key = '<leader>sh', desc = 'Highlight', handler = h.telescope.highlights },
  { key = '<leader>sk', desc = 'Key Mapping', handler = h.telescope.keymaps },
  { key = '<leader>sm', desc = 'Marks', handler = h.telescope.marks },
  { key = '<leader>sM', desc = 'Man Page', handler = h.telescope.man_pages },
  { key = '<leader>so', desc = 'Old File', handler = h.telescope.oldfiles },
  { key = '<leader>sO', desc = 'Open Files', handler = h.telescope.live_grep_open_file },
  { key = '<leader>ss', desc = 'Session', handler = h.telescope.search_session },
  { key = '<leader>st', desc = 'Todo', handler = h.telescope.todo },
  { key = '<leader>sb', desc = 'Buffer', handler = h.telescope.buffers },
  { key = '<leader>sc', desc = 'Config Path', handler = h.telescope.live_grep_config },
  { key = '<leader>sp', desc = 'Plugin Path', handler = h.telescope.live_grep_plugin },
  { key = '<leader>sP', desc = 'Picker', handler = h.telescope.pickers },
  { key = '<leader>sr', desc = 'Root Path', handler = h.telescope.live_grep_root },
  { key = '<leader>fc', desc = 'Config Path', handler = h.telescope.find_file_config },
  { key = '<leader>fp', desc = 'Plugin Path', handler = h.telescope.find_file_plugin },
  { key = '<leader>fr', desc = 'Root Path', handler = h.telescope.find_file_root },
  { key = '<leader>s/', desc = 'Current Buffer', handler = h.telescope.current_buffer_fuzzy_find },

  -- Nvim Tree
  { key = '<m-e>', desc = 'Open, Focus, or Reveal', handler = h.tree.open_focus_reveal },

  -- Context
  { key = '<leader>tc', desc = 'Context', handler = h.toggle_context },

  -- Window Resizer
  { key = '<up>', desc = 'Resize Top', handler = h.resize_wrap('top'), fallback = true, expr = true },
  { key = '<down>', desc = 'Resize Bottom', handler = h.resize_wrap('bottom'), fallback = true, expr = true },
  { key = '<left>', desc = 'Resize Left', handler = h.resize_wrap('left'), fallback = true, expr = true },
  { key = '<right>', desc = 'Resize Right', handler = h.resize_wrap('right'), fallback = true, expr = true },
  { key = '<s-up>', desc = 'Resize Top', handler = h.resize_wrap('top', true), fallback = true, expr = true },
  { key = '<s-down>', desc = 'Resize Bottom', handler = h.resize_wrap('bottom', true), fallback = true, expr = true },
  { key = '<s-left>', desc = 'Resize Left', handler = h.resize_wrap('left', true), fallback = true, expr = true },
  { key = '<s-right>', desc = 'Resize Right', handler = h.resize_wrap('right', true), fallback = true, expr = true },

  -- Debugger
  { key = '<m-b>', desc = 'Toggle Breakpoint', handler = h.dap.toggle_breakpoint },
  { key = '<leader>tv', desc = 'Dap Virtual Text', handler = h.dap.toggle_virtual_text },
  { key = '<leader>dl', desc = 'Log Point', handler = h.dap.set_log_point },
  { key = '<leader>dc', desc = 'Condition Breakpoint', handler = h.dap.set_condition_breakpoint },
  { key = '<leader>dh', desc = 'Hit Count Breakpoint', handler = h.dap.set_hit_count_breakpoint },
  { key = '<leader>de', desc = 'Exception Breakpoints', handler = h.dap.set_exception_breakpoints },
  { key = '<leader>dC', desc = 'Clear Breakpoint', handler = h.dap.clear_breakpoints },
  { key = '<leader>ds', desc = 'Show Breakpoint Information', handler = h.dap.show_breakpoint_info },
  { key = '<f4>', desc = 'Dap Terminate', handler = h.dap.terminate },
  { key = '<f5>', desc = 'Dap Continue', handler = h.dap.continue },
  { key = { '<s-f5>', '<f17>' }, desc = 'Dap Reverse Continue', handler = h.dap.reverse_continue },
  { key = '<f6>', desc = 'Dap Run Last or Restart', handler = h.dap.restart_or_run_last },
  { key = '<F7>', desc = 'Dap Run to Cursor', handler = h.dap.run_to_cursor },
  { key = '<f9>', desc = 'Dap Step Back', handler = h.dap.step_back },
  { key = '<f10>', desc = 'Dap Step Over', handler = h.dap.step_over },
  { key = '<f11>', desc = 'Dap Step Into', handler = h.dap.step_into },
  { key = '<f12>', desc = 'Dap Step Out', handler = h.dap.step_out },

  -- treesj
  { key = 'gJ', desc = 'Treesitter Join', handler = h.treesitter_join },
  { key = 'gS', desc = 'Treesitter Split', handler = h.treesitter_split },
}
require('maplayer').setup(opts)
