return {
  'Kaiser-Yang/maplayer.nvim',
  event = 'VeryLazy',
  config = function()
    -- We have provide another key binding for commenting current line
    -- We must remove this to make "gc" work
    vim.api.nvim_del_keymap('n', 'gcc')
    -- We will map those keys on "LspAttach"
    vim.api.nvim_del_keymap('n', 'grn')
    vim.api.nvim_del_keymap('n', 'gra')
    vim.api.nvim_del_keymap('n', 'grr')
    vim.api.nvim_del_keymap('n', 'gri')
    vim.api.nvim_del_keymap('n', 'grt')
    vim.api.nvim_del_keymap('n', 'gO')
    vim.api.nvim_del_keymap('i', '<c-s>')
    -- When all key bindings has no overlapping,
    -- you can set "timeoutlen" with zero
    -- The default satisfy the requirement.
    -- When you update key bindings, be careful to check if there is any overlapping,
    -- if there is, you should set "timeoutlen" with a proper value such as 300 or 500
    -- "which-key.nvim" can not be used in vscode neovim extension,
    -- so we must set "timeoutlen" with a proper value to make it work
    vim.o.timeoutlen = vim.g.vscode and 300 or 0
    local u = require('lightboat.util')
    local h = require('lightboat.handler')
    local l_dir = vim.fn.fnameescape(u.lazy_path())
    local c_dir = vim.fn.fnameescape(vim.fn.stdpath('config'))
    -- stylua: ignore start
    require('maplayer').setup({
      -- Basic
      -- By default "<C-A>" is used to insert all commands in command mode
      -- and is used to insert previously inserted text in insert mode
      { key = '<c-a>', mode = 'ci', desc = 'Cursor to BOL', handler = h.cursor_to_bol, fallback = false },
      { key = '<m-c>', mode = 'nox', desc = 'System Yank', handler = h.system_yank, expr = true, fallback = false },
      { key = '<m-d>', mode = 'ci', desc = 'Delete to EOW', handler = h.delete_to_eow, fallback = false },
      { key = '<m-n>', mode = 'c', desc = 'Next Commend History', handler = '<down>', fallback = false },
      { key = '<m-p>', mode = 'c', desc = 'Previous Commend History', handler = '<up>', fallback = false },
      { key = '<m-v>', mode = 'cinx', desc = 'System Put', handler = h.system_put, fallback = false },
      { key = '<m-x>', mode = 'nox', desc = 'System Cut', handler = h.system_cut, expr = true, fallback = false },
      { key = '<m-C>', desc = 'System Yank EOL', handler = h.system_yank_eol, fallback = false },
      { key = '<m-V>', desc = 'System Put Before', handler = h.system_put_before, fallback = false },
      { key = '<m-X>', desc = 'System Cut EOL', handler = h.system_cut_eol, fallback = false },
      { key = '<m-/>', mode = 'inx', desc = 'Toggle Comment', handler = h.toggle_comment, fallback = false },
      { key = '<m-g>', mode = 'nt', desc = 'Toggle Lazygit', handler = h.toggle_lazygit, fallback = false },
      { key = '<leader>ti', desc = 'Inlay Hint', handler = h.toggle_inlay_hint, fallback = false },
      { key = '<leader>ts', desc = 'Spell', handler = h.toggle_spell, fallback = false },
      { key = '<leader>tt', desc = 'Treesitter Highlight', handler = h.toggle_treesitter },
      { key = { 'ae', 'ie' }, mode = 'ox', desc = 'Edit', handler = h.select_file, fallback = false },
      { key = '&', desc = 'Last Substitute with Flag', handler = '<cmd>&&<cr>', fallback = false },

      -- Repmove Motion
      { key = ';', mode = 'nx', desc = 'Repeat Last Motion Forward', handler = h.semicolon, fallback = false },
      { key = ',', mode = 'nx', desc = 'Repeat Last Motion Backward', handler = h.comma, fallback = false },
      { key = 'f', mode = 'nx', desc = 'Move to Next Character', handler = h.f, fallback = false },
      { key = 'F', mode = 'nx', desc = 'Move to Previous Character', handler = h.F, fallback = false },
      { key = 't', mode = 'nx', desc = 'Move till Next Character', handler = h.t, fallback = false },
      { key = 'T', mode = 'nx', desc = 'Move till Previous Character', handler = h.T, fallback = false },
      -- By deafault, "[a" and "]a" are mapped to ":prevvious" and ":next"
      { key = '[a', mode = 'nx', desc = 'Argument Start', handler = h.previous_parameter_start, fallback = false },
      { key = ']a', mode = 'nx', desc = 'Argument Start', handler = h.next_parameter_start, fallback = false },
      -- By deafault, "[A" and "]A" are mapped to ":rewind" and ":last"
      { key = '[A', mode = 'nx', desc = 'Argument End', handler = h.previous_parameter_end, fallback = false },
      { key = ']A', mode = 'nx', desc = 'Argument End', handler = h.next_parameter_end, fallback = false },
      { key = '[b', desc = 'Buffer', handler = h.previous_buffer, fallback = false },
      { key = ']b', desc = 'Buffer', handler = h.next_buffer, fallback = false },
      -- By default, "[c" and "]c" are used to navigate changes in the buffer. In most caes, we cant use "[g" and "]g" to navigate between git hunks
      { key = '[c', mode = 'nx', desc = 'Class Start', handler = h.previous_class_start, fallback = false },
      { key = ']c', mode = 'nx', desc = 'Class Start', handler = h.next_class_start, fallback = false },
      { key = '[C', mode = 'nx', desc = 'Class End', handler = h.previous_class_end, fallback = false },
      { key = ']C', mode = 'nx', desc = 'Class End', handler = h.next_class_end, fallback = false },
      { key = '[d', desc = 'Diagnostic', handler = h.previous_diagnostic, fallback = false },
      { key = ']d', desc = 'Diagnostic', handler = h.next_diagnostic, fallback = false },
      -- By default, "[i", "]i", "[I", and "]I" are used to show information of keywords under cursor
      { key = '[i', mode = 'nx', desc = 'If Start', handler = h.previous_conditional_start, fallback = false },
      { key = ']i', mode = 'nx', desc = 'If Start', handler = h.next_conditional_start, fallback = false },
      { key = '[I', mode = 'nx', desc = 'If End', handler = h.previous_conditional_end, fallback = false },
      { key = ']I', mode = 'nx', desc = 'If End', handler = h.next_conditional_end, fallback = false },
      -- By default "[f" and "]f" are aliases of "gf"
      { key = '[f', mode = 'nx', desc = 'For Start', handler = h.previous_loop_start, fallback = false },
      { key = ']f', mode = 'nx', desc = 'For Start', handler = h.next_loop_start, fallback = false },
      { key = '[F', mode = 'nx', desc = 'For End', handler = h.previous_loop_end, fallback = false },
      { key = ']F', mode = 'nx', desc = 'For End', handler = h.next_loop_end, fallback = false },
      { key = '[l', desc = 'Location', handler = h.previous_location, fallback = false },
      { key = ']l', desc = 'Location', handler = h.next_location, fallback = false },
      { key = '[m', mode = 'nx', desc = 'Method Start', handler = h.previous_function_start, fallback = false },
      { key = ']m', mode = 'nx', desc = 'Method Start', handler = h.next_function_start, fallback = false },
      { key = '[M', mode = 'nx', desc = 'Method End', handler = h.previous_function_end, fallback = false },
      { key = ']M', mode = 'nx', desc = 'Method End', handler = h.next_function_end, fallback = false },
      { key = '[o', mode = 'nx', desc = 'Call Start', handler = h.previous_call_start, fallback = false },
      { key = ']o', mode = 'nx', desc = 'Call Start', handler = h.next_call_start, fallback = false },
      { key = '[O', mode = 'nx', desc = 'Call End', handler = h.previous_call_end, fallback = false },
      { key = ']O', mode = 'nx', desc = 'Call End', handler = h.next_call_end, fallback = false },
      { key = '[q', desc = 'Quickfix', handler = h.previous_quickfix, fallback = false },
      { key = ']q', desc = 'Quickfix', handler = h.next_quickfix, fallback = false },
      -- By default "[r" and "]r" are used to search "rare" words
      { key = '[r', mode = 'nx', desc = 'Return Start', handler = h.previous_return_start, fallback = false },
      { key = ']r', mode = 'nx', desc = 'Return Start', handler = h.next_return_start, fallback = false },
      { key = '[R', mode = 'nx', desc = 'Return End', handler = h.previous_return_end, fallback = false },
      { key = ']R', mode = 'nx', desc = 'Return End', handler = h.next_return_end, fallback = false },
      { key = '[s', mode = 'nx', desc = 'Misspelled Word', handler = h.previous_misspelled, fallback = false },
      { key = ']s', mode = 'nx', desc = 'Misspelled Word', handler = h.next_misspelled, fallback = false },
      -- By default "[t" and "]t" are mapped to ":tp" and ":tn"
      -- Those two below do not support vim.v.count
      { key = '[t', mode = 'nx', desc = 'Todo', handler = h.previous_todo, fallback = false },
      { key = ']t', mode = 'nx', desc = 'Todo', handler = h.next_todo, fallback = false },
      { key = '[[', mode = 'nx', desc = 'Block Start', handler = h.previous_block_start, fallback = false },
      { key = ']]', mode = 'nx', desc = 'Block Start', handler = h.next_block_start, fallback = false },
      { key = '[]', mode = 'nx', desc = 'Block End', handler = h.previous_block_end, fallback = false },
      { key = '][', mode = 'nx', desc = 'Block End', handler = h.next_block_end, fallback = false },

      -- Treesitter Text Object
      { key = 'aa', mode = 'ox', desc = 'Argument', handler = h.around_parameter, fallback = false },
      { key = 'ia', mode = 'ox', desc = 'Argument', handler = h.inside_parameter, fallback = false },
      -- By default, "ab", "aB", "ib" and "iB" are aliases of "a(", "a{", "i(" and "i{" respectively
      -- Therefore we use "al" and "il" here
      { key = 'al', mode = 'ox', desc = 'Block', handler = h.around_block, fallback = false },
      { key = 'il', mode = 'ox', desc = 'Block', handler = h.inside_block, fallback = false },
      { key = 'ac', mode = 'ox', desc = 'Class', handler = h.around_class, fallback = false },
      { key = 'ic', mode = 'ox', desc = 'Class', handler = h.inside_class, fallback = false },
      { key = 'af', mode = 'ox', desc = 'For', handler = h.around_loop, fallback = false },
      { key = 'if', mode = 'ox', desc = 'For', handler = h.inside_loop, fallback = false },
      { key = 'ai', mode = 'ox', desc = 'If', handler = h.around_conditional, fallback = false },
      { key = 'ii', mode = 'ox', desc = 'If', handler = h.inside_conditional, fallback = false },
      { key = 'am', mode = 'ox', desc = 'Method', handler = h.around_function, fallback = false },
      { key = 'im', mode = 'ox', desc = 'Method', handler = h.inside_function, fallback = false },
      { key = 'ao', mode = 'ox', desc = 'Call', handler = h.around_call, fallback = false },
      { key = 'io', mode = 'ox', desc = 'Call', handler = h.inside_call, fallback = false },
      { key = 'ar', mode = 'ox', desc = 'Return', handler = h.around_return, fallback = false },
      { key = 'ir', mode = 'ox', desc = 'Return', handler = h.inside_return, fallback = false },

      -- Swap
      { key = '<m-s>pa', desc = 'Argument', handler = h.swap_with_previous_parameter, fallback = false },
      { key = '<m-s>na', desc = 'Argument', handler = h.swap_with_next_parameter, fallback = false },
      { key = '<m-s>pb', desc = 'Block', handler = h.swap_with_previous_block, fallback = false },
      { key = '<m-s>nb', desc = 'Block', handler = h.swap_with_next_block, fallback = false },
      { key = '<m-s>pc', desc = 'Class', handler = h.swap_with_previous_class, fallback = false },
      { key = '<m-s>nc', desc = 'Class', handler = h.swap_with_next_class, fallback = false },
      { key = '<m-s>pf', desc = 'For', handler = h.swap_with_previous_loop, fallback = false },
      { key = '<m-s>nf', desc = 'For', handler = h.swap_with_next_loop, fallback = false },
      { key = '<m-s>pi', desc = 'If', handler = h.swap_with_previous_conditional, fallback = false },
      { key = '<m-s>ni', desc = 'If', handler = h.swap_with_next_conditional, fallback = false },
      { key = '<m-s>pm', desc = 'Method', handler = h.swap_with_previous_function, fallback = false },
      { key = '<m-s>nm', desc = 'Method', handler = h.swap_with_next_function, fallback = false },
      { key = '<m-s>po', desc = 'Call', handler = h.swap_with_previous_call, fallback = false },
      { key = '<m-s>no', desc = 'Call', handler = h.swap_with_next_call, fallback = false },
      { key = '<m-s>pr', desc = 'Return', handler = h.swap_with_previous_return, fallback = false },
      { key = '<m-s>nr', desc = 'Return', handler = h.swap_with_next_return, fallback = false },

      -- Completion
      -- By default <C-J> is an alias of <CR>
      { key = '<c-j>', mode = 'ic', desc = 'Select Next Completion Item', handler = h.next_completion_item },
      { key = '<c-x>', mode = 'ic', desc = 'Show Completion', handler = h.show_completion, fallback = false },
      { key = '<c-y>', mode = 'ic', desc = 'Accept Completion Item', handler = h.accept_completion_item },
      { key = '<c-s>', mode = 'i', desc = 'Toggle Signature Help', handler = h.toggle_signature, fallback = false },

      -- Format
      -- We will format automatically on save, therefore this one is not used frequently.
      -- It will only be useful when the format on save occurs errors such as timeout
      { key = '<m-F>', desc = 'Async Format', handler = h.async_format, fallback = false },

      -- Surround
      -- By default "s" and "S" in visual mode are aliases of "c"
      { key = 's', mode = 'x', desc = 'Surround', handler = h.surround_visual, count = true, fallback = false },
      { key = 'S', mode = 'x', desc = 'Surround Line Mode', handler = h.surround_visual_line, count = true, fallback = false },
      -- We use this tricky way to make "ys", "cs", "ds", "yS", "cS", "dS", "yss", "ysS", "ySs" and "ySS" work
      -- We do not recommend to update those mappings
      { key = 's', mode = 'o', desc = 'Surround', handler = h.hack_wrap(), fallback = false },
      { key = 'S', mode = 'o', desc = 'Surround Line Mode', handler = h.hack_wrap('_line'), fallback = false },
      -- Because we have an auto pair plugin, those two below are rarely used
      { key = '<c-g>s', mode = 'i', desc = 'Surround', handler = h.surround_insert, fallback = false },
      { key = '<c-g>S', mode = 'i', desc = 'Surround Line Mode', handler = h.surround_insert_line, fallback = false },

      -- Indent
      { key = '[|', mode = 'nox', desc = 'Indent Start', handler = h.indent_top },
      { key = ']|', mode = 'nox', desc = 'Indent End', handler = h.indent_bottom },
      { key = 'i|', mode = 'ox', desc = 'Indent Line', handler = h.inside_indent },
      { key = 'a|', mode = 'ox', desc = 'Indent Line', handler = h.around_indent },
      { key = '<leader>tI', desc = 'Indent Line', handler = h.toggle_indent_line },

      -- Picker
      { key = 'gy', desc = 'Search Register', handler = '<cmd>Telescope registers<cr>', fallback = false },
      { key = '<c-f>', desc = 'Live Grep Frecency', handler = h.live_grep_frecency, fallback = false },
      { key = '<c-p>', desc = 'Find File Frecency', handler = h.find_file_frecency, fallback = false },
      { key = '<f1>', desc = 'Search Help', handler = h.help_tags, fallback = false },
      { key = '<m-r>', desc = 'Resume', handler = '<cmd>Telescope resume<cr>', fallback = false },
      { key = '<m-f>', mode = 'nx', desc = 'Search Word', handler = h.grep_word, fallback = false },
      { key = '<leader>sb', desc = 'Buffer', handler = '<cmd>Telescope buffers<cr>', fallback = false },
      { key = '<leader>scc', desc = 'Config Path', handler = '<cmd>Telescope live_grep_args cwd=' .. c_dir .. '<cr>', fallback = false },
      { key = '<leader>scl', desc = 'Lazy Path', handler = '<cmd>Telescope live_grep_args cwd=' .. l_dir .. '<cr>', fallback = false },
      { key = '<leader>sfc', desc = 'Config Path', handler = '<cmd>Telescope find_files cwd=' .. c_dir .. '<cr>', fallback = false },
      { key = '<leader>sfl', desc = 'Lazy Path', handler = '<cmd>Telescope find_files cwd=' .. l_dir .. '<cr>', fallback = false },
      { key = '<leader>sh', desc = 'Highlight', handler = '<cmd>Telescope highlights<cr>', fallback = false },
      { key = '<leader>sk', desc = 'Key Mapping', handler = '<cmd>Telescope keymaps<cr>', fallback = false },
      { key = '<leader>sm', desc = 'Man Page', handler = '<cmd>Telescope man_pages<cr>', fallback = false },
      { key = '<leader>sp', desc = 'Picker', handler = '<cmd>Telescope<cr>', fallback = false },
      { key = '<leader>st', desc = 'Todo', handler = '<cmd>Telescope todo-comments todo<cr>', fallback = false },

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

      -- Window
      { key = '<c-h>', desc = 'To Left', handler = h.to_left, fallback = false },
      { key = '<c-j>', desc = 'To Bottom', handler = h.to_bottom, fallback = false },
      { key = '<c-k>', desc = 'To Above', handler = h.to_above, fallback = false },
      { key = '<c-l>', desc = 'To Right', handler = h.to_right, fallback = false },

      -- Key with Multi Functionalities
      { key = '<c-e>', mode = 'ic', desc = 'Cancel Completion', handler = h.cancel_completion },
      -- By default, "<c-e>" is used to insert content below the cursor
      -- This hack will make it still work as default when the cusor is already at the end of the line in insert mode
      { key = '<c-e>', mode = 'ic', desc = 'Cursor to EOL', handler = h.cursor_to_eol },
      -- By default, "<c-u>" are used to delete content before
      { key = '<c-u>', mode = 'i', desc = 'Scroll Documentation Up', handler = h.scroll_documentation_up },
      { key = '<c-u>', mode = 'i', desc = 'Scroll Signature Up', handler = h.scroll_signature_up },
      -- By default, "<c-d>" and "<c-t>" are used to delete or add indent in insert mode
      { key = '<c-d>', mode = 'i', desc = 'Scroll Documentation Down', handler = h.scroll_documentation_down, expr = true },
      { key = '<c-d>', mode = 'i', desc = 'Scroll Signature Down', handler = h.scroll_signature_down, expr = true },
      { key = '<cr>', mode = 'i', desc = 'Insert Undo Point', handler = function() u.key.feedkeys('<c-g>u', 'n') return false end },
      { key = '<cr>', mode = 'i', desc = 'Autopair CR', handler = h.auto_pair_wrap('<cr>'), expr = true },
      { key = '<tab>', mode = 'i', desc = 'Snippet Forward', handler = h.snippet_forward },
      { key = '<tab>', mode = 'i', desc = 'Auto Indent', handler = h.auto_indent },
      { key = '<tab>', mode = 'i', desc = 'Autopair Tabout', handler = h.auto_pair_wrap('<tab>') },
      { key = '<s-tab>', mode = 'i', desc = 'Snippet Backward', handler = h.snippet_backward },
      { key = '<s-tab>', mode = 'i', desc = 'Autopair Reverse Tabout', handler = h.auto_pair_wrap('<s-tab>') },
      -- By default, "<c-k>" is used to insert digraph, see ":help i_CTRL-K" and ":help c_CTRL-K"
      { key = '<c-k>', mode = 'ic', desc = 'Select Previous Completion Item', handler = h.previous_completion_item },
      { key = '<c-k>', mode = 'ic', desc = 'Delete to EOL', handler = h.delete_to_eol },

      { key = '<m-e>', mode = 'n', desc = 'Open, Focus, or Reveal', handler = h.open_focus_reveal },

      -- Some Disabled Keys
      { key = '[s', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = ']s', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = ']f', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = '[F', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = ']m', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = '[M', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = '[o', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = ']o', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = '[O', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = ']O', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
    })
    -- stylua: ignore end
    require('which-key').add({
      { '<leader>g', buffer = true, icon = { icon = ' ', color = 'red' }, desc = 'Git', mode = 'nx' },
      { '<leader>x', buffer = true, icon = { icon = ' ', color = 'red' }, desc = 'Conflict' },
      { '<leader>xd', buffer = true, icon = { icon = ' ', color = 'red' }, desc = 'Diff' },
      { '<leader>tg', buffer = true, icon = { icon = ' ', color = 'yellow' }, desc = 'Git' },
      { '<leader>t', icon = { icon = ' ', color = 'yellow' }, desc = 'Toggle' },
      { '<leader>s', icon = { icon = ' ', color = 'green' }, desc = 'Search' },
      { '<leader>sf', icon = { icon = ' ', color = 'green' }, desc = 'File' },
      { '<leader>sc', icon = { icon = ' ', color = 'green' }, desc = 'Content' },
      { 'a', desc = 'Around', mode = 'xo' },
      { 'i', desc = 'Inside', mode = 'xo' },
      { '*', desc = 'Search Backward', icon = { icon = ' ', color = 'green' }, mode = 'x' },
      { '#', desc = 'Search Forward', icon = { icon = ' ', color = 'green' }, mode = 'x' },
      { '@', desc = 'Execute Register', mode = 'x' },
      { 'Q', desc = 'Repeat Last Recorded Macro', mode = 'x' },
      { '<m-s>', desc = 'Swap', icon = { icon = '󰓡 ', color = 'green' } },
      { '<m-s>p', desc = 'Previous', icon = { icon = '󰓡 ', color = 'green' } },
      { '<m-s>n', desc = 'Next', icon = { icon = '󰓡 ', color = 'green' } },
      { '[', desc = 'Previous', mode = 'nxo', icon = { icon = ' ', color = 'green' } },
      { ']', desc = 'Next', mode = 'nxo', icon = { icon = ' ', color = 'green' } },
      { 'gr', desc = 'LSP', mode = 'nx', icon = { icon = ' ', color = 'orange' } },
    })
  end,
}
