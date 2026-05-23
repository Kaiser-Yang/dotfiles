local u = require('utils')
vim.pack.add({ u.gh('Kaiser-Yang/maplayer.nvim') }, { confirm = false })

-- We have provide another key binding for commenting current line
-- We must remove this to make "gc" work
vim.api.nvim_del_keymap('n', 'gcc')
-- We will map those keys on "LspAttach"
vim.api.nvim_del_keymap('n', 'grn')
vim.api.nvim_del_keymap('n', 'grx')
vim.api.nvim_del_keymap('n', 'gra')
vim.api.nvim_del_keymap('n', 'grr')
vim.api.nvim_del_keymap('n', 'gri')
vim.api.nvim_del_keymap('n', 'grt')
vim.api.nvim_del_keymap('n', 'gO')
vim.api.nvim_del_keymap('i', '<c-s>')
local h = require('handler')
local l_dir = vim.fn.fnameescape(u.plugin_path())
local c_dir = vim.fn.fnameescape(vim.fn.stdpath('config'))
local live_grep_c_dir = '<cmd>Telescope live_grep_args cwd=' .. c_dir .. '<cr>'
local live_grep_l_dir = '<cmd>Telescope live_grep_args cwd=' .. l_dir .. '<cr>'
local find_files_c_dir = '<cmd>Telescope find_files cwd=' .. c_dir .. '<cr>'
local find_files_l_dir = '<cmd>Telescope find_files cwd=' .. l_dir .. '<cr>'
local function live_grep_open_file()
  require('telescope.builtin').live_grep({
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  })
  return true
end
-- stylua: ignore start
local opts = {
  -- Builtin
  { key = '<m-x>', mode = 'nox', desc = 'System Cut', handler = h.builtin.system_cut, expr = true },
  { key = '<m-c>', mode = 'nox', desc = 'System Yank', handler = h.builtin.system_yank, expr = true },
  { key = '<m-v>', mode = 'cinx', desc = 'System Put', handler = h.builtin.system_put, expr = true },
  { key = '<m-X>', desc = 'System Cut EOL', handler = h.builtin.system_cut_eol, expr = true },
  { key = '<m-C>', desc = 'System Yank EOL', handler = h.builtin.system_yank_eol, expr = true },
  { key = '<m-V>', mode = 'nx', desc = 'System Put Before', handler = h.builtin.system_put_before, expr = true },
  { key = '<m-d>', mode = 'ci', desc = 'Delete to EOW', handler = h.builtin.delete_to_eow },
  { key = '<m-g>', mode = 'nt', desc = 'Toggle Lazygit', handler = h.builtin.toggle_lazygit },
  { key = '<m-/>', mode = 'inx', desc = 'Toggle Line Comment', handler = h.builtin.toggle_comment, expr = true },
  { key = '<c-h>', desc = 'To Left', handler = h.builtin.to_left, expr = true },
  { key = '<c-j>', desc = 'To Bottom', handler = h.builtin.to_bottom, expr = true },
  { key = '<c-k>', desc = 'To Above', handler = h.builtin.to_above, expr = true },
  { key = '<c-l>', desc = 'To Right', handler = h.builtin.to_right, expr = true },
  { key = '<c-w>T', desc = 'Tab Split', handler = h.builtin.tab_split },
  -- By default "<C-A>" is used to insert all commands in command mode
  -- and is used to insert previously inserted text in insert mode
  { key = '<c-a>', mode = 'ci', desc = 'Cursor to BOL', handler = h.builtin.cursor_to_bol },
  -- By default, "<c-e>" is used to insert content below the cursor
  -- This hack will make it still work as default when the cusor is already at the end of the line in insert mode
  { key = '<c-e>', mode = 'ci', desc = 'Cursor to EOL', handler = h.builtin.cursor_to_eol, fallback = true, priority = 0 },
  { key = '<c-k>', mode = 'ci', desc = 'Delete to EOL', handler = h.builtin.delete_to_eol, fallback = true, priority = 0 },
  { key = '<c-p>', mode = 'ci', desc = 'Nop', handler = h.builtin.nop },
  { key = '<c-n>', mode = 'ci', desc = 'Nop', handler = h.builtin.nop },
  { key = '&', desc = 'Last Substitute with Flag', handler = h.builtin.last_s_cmd },
  { key = '<m-n>', mode = 'c', desc = 'Next Commend History', handler = h.builtin.down },
  { key = '<m-p>', mode = 'c', desc = 'Previous Commend History', handler = h.builtin.up },
  { key = '<leader>r', desc = 'Run Single File', handler = h.builtin.run_single_file },
  { key = '<leader>ts', desc = 'Spell', handler = h.builtin.toggle_spell },
  { key = '<leader>ti', desc = 'Inlay Hint', handler = h.builtin.toggle_inlay_hint },
  { key = '<leader>tt', desc = 'Treesitter Highlight', handler = h.builtin.toggle_treesitter },
  { key = '<leader>q', desc = 'Diagnostic Quickfix', handler = h.builtin.diagnostic_qflist },
  { key = '<leader>l', desc = 'Diagnostic Loclist', handler = h.builtin.diagnostic_loclist },
  { key = { 'ae', 'ie' }, mode = 'ox', desc = 'Edit', handler = h.builtin.select_file },
  { key = { '<esc>', '<c-[>' }, desc = 'No Highlight Search', handler = h.builtin.no_hl_search },

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
  { key = '[l', desc = 'Location', handler = h.repmove.previous_location },
  { key = ']l', desc = 'Location', handler = h.repmove.next_location },
  { key = '[q', desc = 'Quickfix', handler = h.repmove.previous_quickfix },
  { key = ']q', desc = 'Quickfix', handler = h.repmove.next_quickfix },

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
  { key = 'aa', mode = 'ox', desc = 'Argument', handler = h.treesitter.around_parameter },
  { key = 'ia', mode = 'ox', desc = 'Argument', handler = h.treesitter.inside_parameter },
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
  { key = '<c-u>', mode = 'i', desc = 'Scroll Documentation Up', handler = h.completion.scroll_documentation_up, fallback = true },
  { key = '<c-u>', mode = 'i', desc = 'Scroll Signature Up', handler = h.completion.scroll_signature_up, fallback = true },
  -- By default, "<c-d>" and "<c-t>" are used to delete or add indent in insert mode
  { key = '<c-d>', mode = 'i', desc = 'Scroll Documentation Down', handler = h.completion.scroll_documentation_down, expr = true, fallback = true },
  { key = '<c-d>', mode = 'i', desc = 'Scroll Signature Down', handler = h.completion.scroll_signature_down, expr = true, fallback = true },
  { key = '<tab>', mode = 'i', desc = 'Snippet Forward', handler = h.completion.snippet_forward, fallback = true },
  { key = '<s-tab>', mode = 'i', desc = 'Snippet Backward', handler = h.completion.snippet_backward },
  -- By default <C-J> is an alias of <CR>
  { key = '<c-j>', mode = 'ci', desc = 'Select Next Completion Item', handler = h.completion.next_completion_item, fallback = true },
  -- By default, "<c-k>" is used to insert digraph, see ":help i_CTRL-K" and ":help c_CTRL-K"
  { key = '<c-k>', mode = 'ci', desc = 'Select Previous Completion Item', handler = h.completion.previous_completion_item, fallback = true, priority = 1 },
  -- By default "<c-y>" is used to insert content above the cursor
  { key = '<c-y>', mode = 'ci', desc = 'Accept Completion Item', handler = h.completion.accept_completion_item, fallback = true },
  -- By default, "<c-e>" is used to insert content below the cursor
  { key = '<c-e>', mode = 'ci', desc = 'Cancel Completion', handler = h.completion.cancel_completion, fallback = true, priority = 1 },

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
  { key = 's', mode = 'o', desc = 'Surround', handler = h.pair.hack_wrap() },
  { key = 'S', mode = 'o', desc = 'Surround Line Mode', handler = h.pair.hack_wrap('_line') },

  -- Indent
  { key = 'i|', mode = 'ox', desc = 'Indent Line', handler = h.blink_indent.inside_indent },
  { key = 'a|', mode = 'ox', desc = 'Indent Line', handler = h.blink_indent.around_indent },
  { key = '<leader>tI', desc = 'Indent Line', handler = h.blink_indent.toggle_indent_line },

  -- Picker
  { key = 'gy', desc = 'Search Register', handler = '<cmd>Telescope registers<cr>' },
  { key = '<c-f>', desc = 'Live Grep Arg', handler = h.live_grep_arg, fallback = false },
  { key = '<c-p>', desc = 'Find File', handler = h.find_file, fallback = false },
  { key = '<f1>', desc = 'Search Help', handler = h.help_tags, fallback = false },
  { key = '<m-r>', desc = 'Resume', handler = '<cmd>Telescope resume<cr>' },
  { key = '<m-f>', mode = 'nx', desc = 'Find Word', handler = h.find_word, fallback = false },
  { key = '<m-e>', mode = 'n', desc = 'Open, Focus, or Reveal', handler = h.open_focus_reveal, fallback = false },
  { key = '<leader>sb', desc = 'Buffer', handler = '<cmd>Telescope buffers<cr>' },
  { key = '<leader>scc', desc = 'Config Path', handler = live_grep_c_dir },
  { key = '<leader>scl', desc = 'Lazy Path', handler = live_grep_l_dir },
  { key = '<leader>sfc', desc = 'Config Path', handler = find_files_c_dir },
  { key = '<leader>sfl', desc = 'Lazy Path', handler = find_files_l_dir },
  { key = '<leader>sd', desc = 'Diagnostics', handler = '<cmd>Telescope diagnostics<cr>' },
  { key = '<leader>sq', desc = 'Quickfix', handler = '<cmd>Telescope quickfix<cr>' },
  { key = '<leader>sl', desc = 'Loclist', handler = '<cmd>Telescope loclist<cr>' },
  { key = '<leader>sh', desc = 'Highlight', handler = '<cmd>Telescope highlights<cr>' },
  { key = '<leader>sk', desc = 'Key Mapping', handler = '<cmd>Telescope keymaps<cr>' },
  { key = '<leader>sm', desc = 'Man Page', handler = '<cmd>Telescope man_pages<cr>' },
  { key = '<leader>sp', desc = 'Picker', handler = '<cmd>Telescope<cr>' },
  { key = '<leader>sr', desc = 'Recent Files', handler = '<cmd>Telescope oldfiles<cr>' },
  { key = '<leader>st', desc = 'Todo', handler = '<cmd>Telescope todo-comments todo<cr>' },
  { key = '<leader>/', desc = 'Current Buffer Fuzzy Search', handler = '<cmd>Telescope current_buffer_fuzzy_find<cr>' },
  { key = '<leader>s/', desc = 'Search in Open Files', handler = live_grep_open_file },

  -- Autopair
  { key = '(', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('(') },
  { key = ')', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap(')') },
  { key = '[', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('[') },
  { key = ']', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap(']') },
  { key = '{', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('{') },
  { key = '}', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('}') },
  { key = '<', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('<') },
  { key = '>', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('>') },
  { key = '!', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('!') },
  { key = '-', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('-') },
  { key = '_', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('_') },
  { key = '*', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('*') },
  { key = '$', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('$') },
  { key = '"', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('"') },
  { key = "'", mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap("'") },
  { key = '`', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('`') },
  { key = '<bs>', mode = 'i', desc = 'Autopair BS', handler = h.auto_pair_wrap('<bs>') },
  { key = '<space>', mode = 'i', desc = 'Autopair Space', handler = h.auto_pair_wrap('<space>') },
  { key = '<m-e>', mode = 'i', desc = 'Autopair Fastwarp', handler = h.auto_pair_wrap('<m-e>') },
  { key = '<m-E>', mode = 'i', desc = 'Autopair Reverse Fastwarp', handler = h.auto_pair_wrap('<m-E>') },
  { key = '<m-s>', mode = 'i', desc = 'Autopair Surround', handler = h.auto_pair_wrap('<m-)>') },

  -- Window Resizer
  { key = '<up>', desc = 'Resize Top', handler = h.resize_wrap('top'), fallback = true, expr = true },
  { key = '<down>', desc = 'Resize Bottom', handler = h.resize_wrap('bottom'), fallback = true, expr = true },
  { key = '<left>', desc = 'Resize Left', handler = h.resize_wrap('left'), fallback = true, expr = true },
  { key = '<right>', desc = 'Resize Right', handler = h.resize_wrap('right'), fallback = true, expr = true },
  { key = '<s-up>', desc = 'Resize Top', handler = h.resize_wrap('top', true), fallback = true, expr = true },
  { key = '<s-down>', desc = 'Resize Bottom', handler = h.resize_wrap('bottom', true), fallback = true, expr = true },
  { key = '<s-left>', desc = 'Resize Left', handler = h.resize_wrap('left', true), fallback = true, expr = true },
  { key = '<s-right>', desc = 'Resize Right', handler = h.resize_wrap('right', true), fallback = true, expr = true },

  -- Key with Multi Functionalities
  -- By default, "<c-e>" is used to insert content below the cursor
  -- This hack will make it still work as default when the cusor is already at the end of the line in insert mode
  { key = '<cr>', mode = 'i', desc = 'Insert Undo Point', handler = insert_undo_point },
  { key = '<cr>', mode = 'i', desc = 'Autopair CR', handler = h.auto_pair_wrap('<cr>'), expr = true },
  { key = '<c-k>', mode = 'ic', desc = 'Delete to EOL', handler = h.builtin.delete_to_eol },

  -- Debugger
  { key = '<leader>tb', desc = 'Breakpoint', handler = '<cmd>DapToggleBreakpoint<cr>' },
  { key = '<leader>td', desc = 'Dap View', handler = h.toggle_dap_view },
  { key = '<leader>dl', desc = 'Set Log Point', handler = h.set_log_point },
  { key = '<leader>dc', desc = 'Set Condition Breakpoint', handler = h.set_condition_breakpoint },
  { key = '<leader>dC', desc = 'Clear Breakpoint', handler = '<cmd>DapClearBreakpoints<cr>' },
  { key = '<f4>', desc = 'Dap Terminate', handler = '<cmd>DapTerminate<cr>' },
  { key = '<f5>', desc = 'Dap Continue', handler = '<cmd>DapContinue<cr>' },
  { key = '<f6>', desc = 'Dap Run Last or Restart', handler = h.restart_or_run_last },
  { key = '<f9>', desc = 'Dap Step Back', handler = function() require('dap').step_back() end },
  { key = '<f10>', desc = 'Dap Step Over', handler = '<cmd>DapStepOver<cr>' },
  { key = '<f11>', desc = 'Dap Step Into', handler = '<cmd>DapStepInto<cr>' },
  { key = '<f12>', desc = 'Dap Step Out', handler = '<cmd>DapStepOut<cr>' },

  -- Disable some keys
  { key = '<tab>', mode = 'c', handler = '<c-v><tab>' },
  { key = '<s-tab>', mode = 'c', handler = '<c-v><s-tab>' },
}
require('maplayer').setup(opts)
