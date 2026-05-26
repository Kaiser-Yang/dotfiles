local u = require('utils')
u.gh('Kaiser-Yang/maplayer.nvim')

-- We have provide another key binding for commenting current line
-- We must remove this to make "gc" work
vim.api.nvim_del_keymap('n', 'gcc')
local h = require('handler')
local opts = {
  -- Builtin
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
  { key = '<m-d>', mode = 'ci', desc = 'Delete to EOW', handler = h.builtin.delete_to_eow },
  { key = '<m-g>', mode = 'nt', desc = 'Toggle Lazygit', handler = h.builtin.toggle_lazygit },
  { key = '<m-/>', mode = 'inx', desc = 'Toggle Line Comment', handler = h.builtin.toggle_comment },
  { key = '<c-h>', desc = 'To Left', handler = h.builtin.to_left },
  { key = '<c-j>', desc = 'To Bottom', handler = h.builtin.to_bottom },
  { key = '<c-k>', desc = 'To Above', handler = h.builtin.to_above },
  { key = '<c-l>', desc = 'To Right', handler = h.builtin.to_right },
  { key = '<c-w>T', desc = 'Tab Split', handler = h.builtin.tab_split },
  -- By default "<C-A>" is used to insert all commands in command mode
  -- and is used to insert previously inserted text in insert mode
  { key = '<c-a>', mode = 'ci', desc = 'Cursor to BOL', handler = h.builtin.cursor_to_bol },
  -- By default, "<c-e>" is used to insert content below the cursor
  -- This hack will make it still work as default when the cusor is already at the end of the line in insert mode
  {
    key = '<c-e>',
    mode = 'ci',
    desc = 'Cursor to EOL',
    handler = h.builtin.cursor_to_eol,
    fallback = true,
    priority = 0,
  },
  {
    key = '<c-k>',
    mode = 'ci',
    desc = 'Delete to EOL',
    handler = h.builtin.delete_to_eol,
    fallback = true,
    priority = 0,
  },
  { key = '&', desc = 'Last Substitute with Flag', handler = h.builtin.last_s_cmd },
  { key = '<m-n>', mode = 'c', desc = 'Next Commend History', handler = h.builtin.down },
  { key = '<m-p>', mode = 'c', desc = 'Previous Commend History', handler = h.builtin.up },
  { key = '<leader>r', desc = 'Run Single File', handler = h.builtin.run_single_file },
  { key = '<leader>ts', desc = 'Spell', handler = h.builtin.toggle_spell },
  { key = '<leader>tt', desc = 'Treesitter Highlight', handler = h.builtin.toggle_treesitter },
  { key = '<leader>q', desc = 'Diagnostic Qflist', handler = h.builtin.diagnostic_qflist },
  { key = '<leader>l', desc = 'Diagnostic Loclist', handler = h.builtin.diagnostic_loclist },
  { key = { 'ae', 'ie' }, mode = 'ox', desc = 'Edit', handler = h.builtin.select_file },
  { key = { '<esc>', '<c-[>' }, desc = 'No Highlight Search', handler = h.builtin.no_hl_search },
  { key = 'aa', mode = 'ox', desc = '<> block', handler = h.builtin.around_angle_bracket },
  { key = 'ia', mode = 'ox', desc = '<> block', handler = h.builtin.inside_angle_bracket },

  -- LSP
  -- INFO:
  -- By default, "tagfunc" is set whne "LspAttach",
  -- "<C-]>", "<C-W>]", and "<C-W>}" will work, you can use them to go to definition
  { key = 'K', desc = 'Hover', handler = h.lsp.hover },
  { key = 'grn', desc = 'Rename', handler = h.lsp.rename },
  { key = 'gra', desc = 'Code Action', handler = h.lsp.code_action },
  { key = 'grD', desc = 'Declaration', handler = h.lsp.declaration },
  { key = 'grx', desc = 'Codelens', handler = h.lsp.codelens_run },
  { key = 'grr', desc = 'References', handler = h.lsp.references },
  { key = 'grI', desc = 'Implementation', handler = h.lsp.implementation },
  { key = 'gri', desc = 'Incoming Call', handler = h.lsp.incoming_calls },
  { key = 'gro', desc = 'Outgoing Call', handler = h.lsp.outgoing_calls },
  { key = 'grt', desc = 'Type Definition', handler = h.lsp.type_definition },
  { key = 'gO', desc = 'Document Symbol', handler = h.lsp.document_symbol },
  { key = 'gW', desc = 'Dynamic Workspace Symbols', handler = h.lsp.dynamic_workspace_symbols },
  { key = '<leader>ti', desc = 'Inlay Hint', handler = h.lsp.toggle_inlay_hint },
  { key = '<leader>tc', desc = 'Code Lens', handler = h.lsp.toggle_codelens },

  -- Git
  { key = { 'ah', 'ih' }, mode = 'ox', desc = 'Git Hunk', handler = h.git.select_hunk },
  { key = '<leader>ga', mode = 'nx', desc = 'Add', handler = h.git.stage },
  { key = '<leader>gA', desc = 'Add Buffer', handler = h.git.stage_buffer },
  { key = '<leader>gu', desc = 'Undo Add', handler = h.git.undo_stage_hunk },
  { key = '<leader>gU', desc = 'Undo Add Buffer', handler = h.git.reset_buffer_index },
  { key = '<leader>gr', mode = 'nx', desc = 'Reset', handler = h.git.reset },
  { key = '<leader>gR', desc = 'Reset Buffer', handler = h.git.reset_buffer },
  { key = '<leader>gt', desc = 'Git Diff This with Input', handler = h.git.diff_this_with_input, expr = true },
  { key = '<leader>gq', desc = 'Qflist with Input', handler = h.git.qflist_with_input, expr = true },
  { key = '<leader>gl', desc = 'Loclist with Input', handler = h.git.loclist_with_input, expr = true },
  { key = '<leader>gd', desc = 'Diff', handler = h.git.preview_hunk },
  { key = '<leader>gD', desc = 'Diff Inline', handler = h.git.preview_hunk_inline },
  { key = '<leader>gb', desc = 'Line Blame', handler = h.git.line_blame },
  { key = '<leader>gB', desc = 'Buffer Blame', handler = h.git.buffer_blame },
  { key = '<leader>tgb', desc = 'Current Line Blame', handler = h.git.toggle_current_line_blame },
  { key = '<leader>tgw', desc = 'Word Diff', handler = h.git.toggle_word_diff },
  { key = '<leader>tgs', desc = 'Signs', handler = h.git.toggle_signs },
  { key = '<leader>tgn', desc = 'Line Number Highlight', handler = h.git.toggle_numhl },
  { key = '<leader>tgd', desc = 'Deleted', handler = h.git.toggle_deleted },
  { key = '<leader>tgl', desc = 'Line Highlight', handler = h.git.toggle_linehl },

  -- Repmove Motion
  { key = ';', mode = 'nx', desc = 'Last Motion Forward', handler = h.repmove.semicolon },
  { key = ',', mode = 'nx', desc = 'Last Motion Backward', handler = h.repmove.comma },
  { key = 'f', mode = 'nx', desc = 'Move to Next Character', handler = h.repmove.f },
  { key = 'F', mode = 'nx', desc = 'Move to Previous Character', handler = h.repmove.F },
  { key = 't', mode = 'nx', desc = 'Move till Next Character', handler = h.repmove.t },
  { key = 'T', mode = 'nx', desc = 'Move till Previous Character', handler = h.repmove.T },
  -- By deafault, "[a" and "]a" are mapped to ":prevvious" and ":next"
  { key = '[a', mode = 'nox', desc = 'Argument Start', handler = h.repmove.previous_parameter_start },
  { key = ']a', mode = 'nox', desc = 'Argument Start', handler = h.repmove.next_parameter_start },
  -- By deafault, "[A" and "]A" are mapped to ":rewind" and ":last"
  { key = '[A', mode = 'nox', desc = 'Argument End', handler = h.repmove.previous_parameter_end },
  { key = ']A', mode = 'nox', desc = 'Argument End', handler = h.repmove.next_parameter_end },
  -- By default, "[c" and "]c" are used to navigate changes in the buffer.
  -- In most caes, we cant use "[g" and "]g" to navigate between git hunks
  { key = '[c', mode = 'nox', desc = 'Class Start', handler = h.repmove.previous_class_start },
  { key = ']c', mode = 'nox', desc = 'Class Start', handler = h.repmove.next_class_start },
  { key = '[C', mode = 'nox', desc = 'Class End', handler = h.repmove.previous_class_end },
  { key = ']C', mode = 'nox', desc = 'Class End', handler = h.repmove.next_class_end },
  { key = '[d', mode = 'nox', desc = 'Diagnostic', handler = h.repmove.previous_diagnostic },
  { key = ']d', mode = 'nox', desc = 'Diagnostic', handler = h.repmove.next_diagnostic },
  { key = '[g', mode = 'nx', desc = 'Git Hunk', handler = h.repmove.previous_hunk },
  { key = ']g', mode = 'nx', desc = 'Git Hunk', handler = h.repmove.next_hunk },
  -- By default, "[i", "]i", "[I", and "]I" are used to show information of keywords under cursor
  { key = '[i', mode = 'nox', desc = 'If Start', handler = h.repmove.previous_conditional_start },
  { key = ']i', mode = 'nox', desc = 'If Start', handler = h.repmove.next_conditional_start },
  { key = '[I', mode = 'nox', desc = 'If End', handler = h.repmove.previous_conditional_end },
  { key = ']I', mode = 'nox', desc = 'If End', handler = h.repmove.next_conditional_end },
  -- By default "[f" and "]f" are aliases of "gf"
  { key = '[f', mode = 'nox', desc = 'For Start', handler = h.repmove.previous_loop_start },
  { key = ']f', mode = 'nox', desc = 'For Start', handler = h.repmove.next_loop_start },
  { key = '[F', mode = 'nox', desc = 'For End', handler = h.repmove.previous_loop_end },
  { key = ']F', mode = 'nox', desc = 'For End', handler = h.repmove.next_loop_end },
  { key = '[m', mode = 'nox', desc = 'Method Start', handler = h.repmove.previous_function_start },
  { key = ']m', mode = 'nox', desc = 'Method Start', handler = h.repmove.next_function_start },
  { key = '[M', mode = 'nox', desc = 'Method End', handler = h.repmove.previous_function_end },
  { key = ']M', mode = 'nox', desc = 'Method End', handler = h.repmove.next_function_end },
  { key = '[o', mode = 'nox', desc = 'Call Start', handler = h.repmove.previous_call_start },
  { key = ']o', mode = 'nox', desc = 'Call Start', handler = h.repmove.next_call_start },
  { key = '[O', mode = 'nox', desc = 'Call End', handler = h.repmove.previous_call_end },
  { key = ']O', mode = 'nox', desc = 'Call End', handler = h.repmove.next_call_end },
  -- By default "[r" and "]r" are used to search "rare" words
  { key = '[r', mode = 'nox', desc = 'Return Start', handler = h.repmove.previous_return_start },
  { key = ']r', mode = 'nox', desc = 'Return Start', handler = h.repmove.next_return_start },
  { key = '[R', mode = 'nox', desc = 'Return End', handler = h.repmove.previous_return_end },
  { key = ']R', mode = 'nox', desc = 'Return End', handler = h.repmove.next_return_end },
  { key = '[s', mode = 'nox', desc = 'Misspelled Word', handler = h.repmove.previous_misspelled },
  { key = ']s', mode = 'nox', desc = 'Misspelled Word', handler = h.repmove.next_misspelled },
  -- By default "[t" and "]t" are mapped to ":tp" and ":tn"
  -- Those two below do not support vim.v.count
  { key = '[t', mode = 'nox', desc = 'Todo', handler = h.repmove.previous_todo },
  { key = ']t', mode = 'nox', desc = 'Todo', handler = h.repmove.next_todo },
  { key = '[[', mode = 'nox', desc = 'Block Start', handler = h.repmove.previous_block_start },
  { key = ']]', mode = 'nox', desc = 'Block Start', handler = h.repmove.next_block_start },
  { key = '[]', mode = 'nox', desc = 'Block End', handler = h.repmove.previous_block_end },
  { key = '][', mode = 'nox', desc = 'Block End', handler = h.repmove.next_block_end },
  { key = '[|', mode = 'nox', desc = 'Indent Start', handler = h.repmove.indent_top },
  { key = ']|', mode = 'nox', desc = 'Indent End', handler = h.repmove.indent_bottom },
  { key = '[b', desc = 'Buffer', handler = h.repmove.previous_buffer },
  { key = ']b', desc = 'Buffer', handler = h.repmove.next_buffer },
  { key = '[l', desc = 'Loclist Item', handler = h.repmove.previous_loclist_item },
  { key = ']l', desc = 'Loclist Item', handler = h.repmove.next_loclist_item },
  { key = '[q', desc = 'Qflist Item', handler = h.repmove.previous_qflist_item },
  { key = ']q', desc = 'Qflist Item', handler = h.repmove.next_qflist_item },

  -- Swap
  { key = '<m-s>pa', desc = 'Argument', handler = h.treesitter.swap_with_previous_parameter },
  { key = '<m-s>na', desc = 'Argument', handler = h.treesitter.swap_with_next_parameter },
  { key = '<m-s>pl', desc = 'Block', handler = h.treesitter.swap_with_previous_block },
  { key = '<m-s>nl', desc = 'Block', handler = h.treesitter.swap_with_next_block },
  { key = '<m-s>pc', desc = 'Class', handler = h.treesitter.swap_with_previous_class },
  { key = '<m-s>nc', desc = 'Class', handler = h.treesitter.swap_with_next_class },
  { key = '<m-s>pf', desc = 'For', handler = h.treesitter.swap_with_previous_loop },
  { key = '<m-s>nf', desc = 'For', handler = h.treesitter.swap_with_next_loop },
  { key = '<m-s>pi', desc = 'If', handler = h.treesitter.swap_with_previous_conditional },
  { key = '<m-s>ni', desc = 'If', handler = h.treesitter.swap_with_next_conditional },
  { key = '<m-s>pm', desc = 'Method', handler = h.treesitter.swap_with_previous_function },
  { key = '<m-s>nm', desc = 'Method', handler = h.treesitter.swap_with_next_function },
  { key = '<m-s>po', desc = 'Call', handler = h.treesitter.swap_with_previous_call },
  { key = '<m-s>no', desc = 'Call', handler = h.treesitter.swap_with_next_call },
  { key = '<m-s>pr', desc = 'Return', handler = h.treesitter.swap_with_previous_return },
  { key = '<m-s>nr', desc = 'Return', handler = h.treesitter.swap_with_next_return },

  -- Treesitter Text Object
  { key = 'aA', mode = 'ox', desc = 'Argument', handler = h.treesitter.around_parameter },
  { key = 'iA', mode = 'ox', desc = 'Argument', handler = h.treesitter.inside_parameter },
  -- By default, "ab", "aB", "ib" and "iB" are aliases of "a(", "a{", "i(" and "i{" respectively
  -- Therefore we use "al" and "il" here
  { key = 'al', mode = 'ox', desc = 'Block', handler = h.treesitter.around_block },
  { key = 'il', mode = 'ox', desc = 'Block', handler = h.treesitter.inside_block },
  { key = 'ac', mode = 'ox', desc = 'Class', handler = h.treesitter.around_class },
  { key = 'ic', mode = 'ox', desc = 'Class', handler = h.treesitter.inside_class },
  { key = 'af', mode = 'ox', desc = 'For', handler = h.treesitter.around_loop },
  { key = 'if', mode = 'ox', desc = 'For', handler = h.treesitter.inside_loop },
  { key = 'ai', mode = 'ox', desc = 'If', handler = h.treesitter.around_conditional },
  { key = 'ii', mode = 'ox', desc = 'If', handler = h.treesitter.inside_conditional },
  { key = 'am', mode = 'ox', desc = 'Method', handler = h.treesitter.around_function },
  { key = 'im', mode = 'ox', desc = 'Method', handler = h.treesitter.inside_function },
  { key = 'ao', mode = 'ox', desc = 'Call', handler = h.treesitter.around_call },
  { key = 'io', mode = 'ox', desc = 'Call', handler = h.treesitter.inside_call },
  { key = 'ar', mode = 'ox', desc = 'Return', handler = h.treesitter.around_return },
  { key = 'ir', mode = 'ox', desc = 'Return', handler = h.treesitter.inside_return },

  -- Completion
  { key = '<c-s>', mode = 'i', desc = 'Toggle Signature Help', handler = h.completion.toggle_signature },
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
  { key = '<tab>', mode = 'i', desc = 'Snippet Forward', handler = h.completion.snippet_forward, fallback = true },
  { key = '<s-tab>', mode = 'i', desc = 'Snippet Backward', handler = h.completion.snippet_backward },
  -- By default <C-J> is an alias of <CR>
  { key = '<c-j>', mode = 'ci', desc = 'Select Next', handler = h.completion.select_next, fallback = true },
  -- By default, "<c-k>" is used to insert digraph, see ":help i_CTRL-K" and ":help c_CTRL-K"
  {
    key = '<c-k>',
    mode = 'ci',
    desc = 'Select Previous',
    handler = h.completion.select_previous,
    fallback = true,
    priority = 1,
  },
  -- By default "<c-y>" is used to insert content above the cursor
  { key = '<c-y>', mode = 'ci', desc = 'Accept', handler = h.completion.accept, fallback = true },
  -- By default, "<c-e>" is used to insert content below the cursor
  { key = '<c-e>', mode = 'ci', desc = 'Cancel', handler = h.completion.cancel, fallback = true, priority = 1 },

  -- Format
  -- We will format automatically on save, therefore this one is not used frequently.
  -- It will only be useful when the format on save occurs errors such as timeout
  { key = '<m-F>', desc = 'Async Format', handler = h.async_format },

  -- Surround
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
  { key = '!', mode = 'i', desc = 'Autopair', handler = h.pair.auto_pair_wrap('!') },
  { key = '-', mode = 'i', desc = 'Autopair', handler = h.pair.auto_pair_wrap('-') },
  { key = '"', mode = 'i', desc = 'Autopair', handler = h.pair.auto_pair_wrap('"') },
  { key = "'", mode = 'i', desc = 'Autopair', handler = h.pair.auto_pair_wrap("'") },
  { key = '`', mode = 'i', desc = 'Autopair', handler = h.pair.auto_pair_wrap('`') },
  { key = '<bs>', mode = 'i', desc = 'Autopair BS', handler = h.pair.auto_pair_wrap('<bs>') },
  { key = '<space>', mode = 'i', desc = 'Autopair Space', handler = h.pair.auto_pair_wrap('<space>') },
  { key = '<cr>', mode = 'i', desc = 'Autopair CR', handler = h.pair.auto_pair_wrap('<cr>'), priority = 0 },
  { key = '<m-e>', mode = 'i', desc = 'Autopair Fastwarp', handler = h.pair.auto_pair_wrap('<m-e>') },
  { key = '<m-E>', mode = 'i', desc = 'Autopair Reverse Fastwarp', handler = h.pair.auto_pair_wrap('<m-E>') },
  { key = '<m-s>', mode = 'i', desc = 'Autopair Close', handler = h.pair.auto_pair_wrap('<m-)>') },
  { key = '<c-l>', mode = 'i', desc = 'Autopair Tabout', handler = h.pair.auto_pair_wrap('<m-tab>') },

  -- Indent
  { key = 'i|', mode = 'ox', desc = 'Indent', handler = h.indent.inside },
  { key = 'a|', mode = 'ox', desc = 'Indent', handler = h.indent.around },
  { key = '<leader>tI', desc = 'Indent', handler = h.indent.toggle },

  -- Picker
  { key = 'gy', desc = 'Search Register', handler = h.telescope.registers },
  { key = '<m-r>', desc = 'Resume', handler = h.telescope.resume },
  { key = '<c-f>', desc = 'Live Grep', handler = h.telescope.live_grep },
  { key = '<c-p>', desc = 'Find File', handler = h.telescope.find_file },
  { key = '<f1>', desc = 'Search Help', handler = h.telescope.help_tags },
  { key = '<m-f>', mode = 'nx', desc = 'Find Word', handler = h.telescope.find_word },
  { key = '<leader>sd', desc = 'Diagnostics', handler = h.telescope.diagnostics },
  { key = '<leader>sq', desc = 'Qflist', handler = h.telescope.qflist },
  { key = '<leader>sl', desc = 'Loclist', handler = h.telescope.loclist },
  { key = '<leader>sh', desc = 'Highlight', handler = h.telescope.highlights },
  { key = '<leader>sk', desc = 'Key Mapping', handler = h.telescope.keymaps },
  { key = '<leader>sm', desc = 'Man Page', handler = h.telescope.man_pages },
  { key = '<leader>ss', desc = 'Picker', handler = h.telescope.pickers },
  { key = '<leader>sr', desc = 'Recent Files', handler = h.telescope.oldfiles },
  { key = '<leader>st', desc = 'Todo', handler = h.telescope.todo },
  { key = '<leader>sb', desc = 'Buffer', handler = h.telescope.buffers },
  { key = '<leader>sc', desc = 'Config Path', handler = h.telescope.live_grep_config },
  { key = '<leader>sp', desc = 'Plugin Path', handler = h.telescope.live_grep_plugin },
  { key = '<leader>fc', desc = 'Config Path', handler = h.telescope.find_file_config },
  { key = '<leader>fp', desc = 'Plugin Path', handler = h.telescope.find_file_plugin },
  { key = '<leader>/', desc = 'Current Buffer Fuzzy Search', handler = h.telescope.current_buffer_fuzzy_find },
  { key = '<leader>s/', desc = 'Search in Open Files', handler = h.telescope.live_grep_open_file },

  -- Nvim Tree
  { key = '<m-e>', desc = 'Open, Focus, or Reveal', handler = h.tree.open_focus_reveal },

  -- Context
  { key = '<leader>tC', desc = 'Context', handler = h.toggle_context },

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
  { key = '<leader>td', desc = 'Dap View', handler = h.dap.toggle_dap_view },
  { key = '<leader>dl', desc = 'Set Log Point', handler = h.dap.set_log_point },
  { key = '<leader>dc', desc = 'Set Condition Breakpoint', handler = h.dap.set_condition_breakpoint },
  { key = '<leader>de', desc = 'Dap Set Exception Breakpoints', handler = h.dap.set_exception_breakpoints },
  { key = '<leader>dC', desc = 'Clear Breakpoint', handler = h.dap.clear_breakpoints },
  { key = '<f4>', desc = 'Dap Terminate', handler = h.dap.terminate },
  { key = '<f5>', desc = 'Dap Continue', handler = h.dap.continue },
  { key = { '<s-f5>', '<f17>' }, desc = 'Dap Reverse Continue', handler = h.dap.reverse_continue },
  { key = '<f6>', desc = 'Dap Run Last or Restart', handler = h.dap.restart_or_run_last },
  { key = '<F7>', desc = 'Dap Run to Cursor', handler = h.dap.run_to_cursor },
  { key = '<f9>', desc = 'Dap Step Back', handler = h.dap.step_back },
  { key = '<f10>', desc = 'Dap Step Over', handler = h.dap.step_over },
  { key = '<f11>', desc = 'Dap Step Into', handler = h.dap.step_into },
  { key = '<f12>', desc = 'Dap Step Out', handler = h.dap.step_out },
}
require('maplayer').setup(opts)
