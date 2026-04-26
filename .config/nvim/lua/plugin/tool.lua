local u = require('utils')

local function load_conform()
  require('conform').setup({
    notify_no_formatters = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      go = { 'goimports' },
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      python = { 'black' },
      sql = { 'sql-formatter' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
    },
    default_format_opts = { lsp_format = 'fallback', stop_after_first = true },
  })

  vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function(ev)
      if not u.enabled('conform_on_save') then return end
      local buffer = ev.buf
      require('conform').format({ bufnr = buffer }, function(err)
        if not u.enabled('conform_on_save_reguess_indent') or err then return end
        vim.schedule_wrap(require('guess-indent').set_from_buffer)(buffer, true, true)
      end)
    end,
  })

  local function setup_conform_expr()
    if not u.enabled('conform_formatexpr_auto_set') then return end
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end

  setup_conform_expr()
  vim.api.nvim_create_autocmd('LspAttach', { callback = setup_conform_expr })
end

local function load_treesitter()
  if #vim.g.lightboat_opt.treesitter_ensure_installed > 0 then
    local ts = require('nvim-treesitter')
    local installed = ts.get_installed()
    local not_installed = vim.tbl_filter(
      function(lang) return not vim.tbl_contains(installed, lang) end,
      vim.g.lightboat_opt.treesitter_ensure_installed
    )
    if #not_installed > 0 then ts.install(not_installed) end
  end
end

local function load_lspconfig()
  -- HACK:
  -- This should be checked when blink.cmp updates
  -- Copied from blink.cmp: lua/blink/cmp/sources/lib/init.lua
  local capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
          commitCharactersSupport = false, -- todo:
          documentationFormat = { 'markdown', 'plaintext' },
          deprecatedSupport = true,
          preselectSupport = false, -- todo:
          tagSupport = { valueSet = { 1 } }, -- deprecated
          insertReplaceSupport = true, -- todo:
          resolveSupport = {
            properties = {
              'documentation',
              'detail',
              'additionalTextEdits',
              'command',
              'data',
              -- todo: support more properties? should test if it improves latency
            },
          },
          insertTextModeSupport = {
            -- todo: support adjustIndentation
            valueSet = { 1 }, -- asIs
          },
          labelDetailsSupport = true,
        },
        completionList = {
          itemDefaults = {
            'commitCharacters',
            'editRange',
            'insertTextFormat',
            'insertTextMode',
            'data',
          },
        },

        contextSupport = true,
        insertTextMode = 1, -- asIs
      },
    },
  }
  vim.lsp.config('*', vim.tbl_deep_extend('force', capabilities, vim.lsp.config['*'].capabilities or {}))
  local lsp_path = vim.fn.stdpath('config')
  if lsp_path:sub(-1) ~= '/' then lsp_path = lsp_path .. '/' end
  lsp_path = lsp_path .. 'after/lsp'
  local servers = vim.fn.glob(lsp_path .. '/**/*.lua', true, true)
  servers = vim.tbl_map(function(path) return vim.fn.fnamemodify(path, ':t:r') end, servers)
  if #servers > 0 then vim.lsp.enable(servers) end
end

local function load_mason()
  require('mason').setup()
  local mason_registry = require('mason-registry')
  local installed = mason_registry.get_installed_package_names()
  local not_installed = vim.tbl_filter(
    function(pack) return not vim.tbl_contains(installed, pack) end,
    vim.g.lightboat_opt.mason_ensure_installed
  )
  if #not_installed > 0 then vim.cmd('MasonInstall ' .. table.concat(not_installed, ' ')) end
end

local function load_treesitter_textobjects() require('nvim-treesitter-textobjects').setup() end

local function load_nvim_tree()
  require('nvim-tree').setup({
    on_attach = function(buffer)
      local a = require('nvim-tree.api')
      local function opts(desc) return { desc = desc, buffer = buffer, noremap = true, silent = true, nowait = true } end
      local h = require('handler')
      local mapping = {
        { 'n', '<cr>', a.node.open.edit, opts('Open') },
        { 'n', '<c-t>', a.node.open.tab, opts('New Tab') },
        { 'n', '<c-s>', a.node.open.horizontal, opts('Horizontal Split') },
        { 'n', '<c-v>', a.node.open.vertical, opts('Vertical Split') },
        { 'n', '<f1>', a.tree.toggle_help, opts('Help') },
        { 'n', '<f5>', a.tree.reload, opts('Refresh') },
        { 'n', '<2-leftmouse>', a.node.open.edit, opts('Open') },
        { 'n', '[g', h.nvim_tree_previous_git, opts('Previous Git') },
        { 'n', ']g', h.nvim_tree_next_git, opts('Next Git') },
        { 'n', ']d', h.nvim_tree_next_diagnostic, opts('Next Diagnostic') },
        { 'n', '[d', h.nvim_tree_previous_diagnostic, opts('Previous Diagnostic') },
        { 'n', 'a', a.fs.create, opts('Create') },
        { 'n', 'r', a.fs.rename, opts('Rename') },
        { 'n', 'o', a.node.open.edit, opts('Open') },
        { 'n', 'h', h.collapse_or_go_to_parent, opts('Collapse or Go to Parent') },
        { 'n', 'l', h.open_folder_or_preview, opts('Open Folder or Preview') },
        { 'n', '<bs>', a.node.navigate.parent_close, opts('Close Directory') },
        { 'n', 'p', a.fs.paste, opts('Paste') },
        { 'n', 'q', a.tree.close, opts('Quit') },
        { 'n', 'H', a.node.collapse, opts('Collapse') },
        { 'n', 'L', a.node.expand, opts('Expand') },
        { 'n', 'Y', h.copy_node_information, opts('Copy Node Information') },
        { 'n', '<c-]>', h.change_root_to_node, opts('CD') },
        { 'n', '<c-o>', h.change_root_to_parent, opts('Up') },
        -- NOTE: this should be focusable by pressing K again
        { 'n', 'K', a.node.show_info_popup, opts('Info') },
        { { 'n', 'x' }, 'y', a.fs.copy.node, opts('Copy') },
        { { 'n', 'x' }, 'd', a.fs.remove, opts('Remove') },
        { { 'n', 'x' }, 'x', a.fs.cut, opts('Cut') },
        { { 'n', 'x' }, 'm', a.marks.toggle, opts('Toggle Bookmark') },
        -- NOTE: Those two are not implemented in visual mode yet
        { { 'n', 'x' }, 'c', h.copy_to, opts('Copy to') },
        { { 'n', 'x' }, 'R', h.rename_full, opts('Rename Full Path or Move') },
        { 'n', 'bd', a.marks.bulk.delete, opts('Delete Bookmarked') },
        { 'n', 'bm', a.marks.bulk.move, opts('Move Bookmarked') },
        { 'n', 'M', a.filter.no_bookmark.toggle, opts('Toggle Filter: No Bookmark') },
        { 'n', 'B', a.filter.no_buffer.toggle, opts('Toggle Filter: No Buffer') },
        { 'n', 'C', a.filter.git.clean.toggle, opts('Toggle Filter: Git Clean') },
        { 'n', 'I', a.filter.git.ignored.toggle, opts('Toggle Filter: Git Ignored') },
        { 'n', 'D', a.filter.dotfiles.toggle, opts('Toggle Filter: Dotfiles') },
        { 'n', 'U', a.filter.custom.toggle, opts('Toggle Filter: Custom') },
        { 'n', 'f', a.filter.live.start, opts('Live Filter: Start') },
        { 'n', 'F', a.filter.live.clear, opts('Live Filter: Clear') },
        { 'n', 'P', a.node.navigate.parent, opts('Parent Directory') },
        { 'n', 'E', a.node.open.toggle_group_empty, opts('Toggle Group Empty') },
        { 'n', '.', a.node.run.cmd, opts('Run Command') },
        { 'n', 's', a.node.run.system, opts('Run System') },
        { 'n', 'S', a.tree.search_node, opts('Search') },
      }
      for _, m in ipairs(mapping) do
        vim.keymap.set(unpack(m))
      end
    end,
    view = {
      number = true,
      relativenumber = true,
      preserve_window_proportions = true,
    },
    renderer = {
      group_empty = true,
      indent_markers = { enable = true },
      hidden_display = 'all',
    },
    diagnostics = { enable = true, show_on_dirs = true },
    modified = { enable = true },
    filters = {
      git_ignored = true,
      dotfiles = not u.in_config_dir(),
      custom = { '^\\.git$' },
    },
    actions = {
      file_popup = { open_win_config = { border = vim.o.winborder } },
      open_file = {
        window_picker = {
          exclude = {
            filetype = {
              'CompetiTest',
              'notify',
              'packer',
              'qf',
              'diff',
              'fugitive',
              'fugitiveblame',
              'smear-cursor',
              'snacks_notif',
              'noice',
            },
            buftype = { 'terminal', 'quickfix', 'prompt' },
          },
        },
      },
    },
  })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'QuitPre' }, {
    nested = false,
    callback = function(ev)
      local tree = require('nvim-tree.api').tree
      if not tree.is_visible() then return end

      -- How many focusable windows do we have? (excluding e.g. incline status window)
      local winCount = 0
      local lastWinId
      for _, winId in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(winId).focusable then
          local buf = vim.api.nvim_win_get_buf(winId)
          if vim.bo[buf].filetype ~= 'NvimTree' then
            lastWinId = winId
            winCount = winCount + 1
          end
        end
      end

      -- We want to quit and only one window besides tree is left
      if ev.event == 'QuitPre' and winCount == 1 and lastWinId == vim.api.nvim_get_current_win() then
        vim.api.nvim_cmd({ cmd = 'qall' }, {})
      end

      -- :bd was probably issued an only tree window is left
      -- Behave as if tree was closed (see `:h :bd`)
      if ev.event == 'BufEnter' and winCount == 0 then
        local should_focus = vim.bo.filetype == 'NvimTree'
        vim.schedule(function()
          -- close nvim-tree: will go to the last buffer used before closing
          tree.toggle()
          -- re-open nivm-tree
          tree.toggle({ find_file = false, focus = should_focus })
        end)
      end
    end,
  })
end

local function find_command()
  local res = { 'rg', '--files', '--color', 'never', '-g', '!.git' }
  if u.in_config_dir() then table.insert(res, '--hidden') end
  return res
end

local additional_args = function()
  local res = { '-g', '!.git' }
  if u.in_config_dir() then table.insert(res, '--hidden') end
  return res
end

local function cursor(opts)
  return vim.tbl_deep_extend('force', {
    theme = 'cursor',
    layout_config = { width = 0.2, height = 0.4 },
  }, opts or {})
end

local function ivy(opts)
  return vim.tbl_deep_extend('force', {
    theme = 'ivy',
    layout_config = { height = 0.4 },
  }, opts or {})
end

local function load_telescope()
  local opts = {
    defaults = {
      mappings = { n = {}, i = {} },
      dynamic_preview_title = true,
      sorting_strategy = 'ascending',
      default_mappings = {},
      layout_config = {
        horizontal = { prompt_position = 'top' },
        width = { padding = 0 },
        height = { padding = 0 },
      },
      cache_picker = { ignore_empty_prompt = true },
    },
    pickers = {
      lsp_references = cursor(),
      lsp_implementations = cursor(),
      lsp_incoming_calls = cursor(),
      lsp_outgoing_calls = cursor(),
      lsp_type_definitions = cursor(),
      lsp_documentation_symbols = ivy(),
      lsp_dynamic_workspace_symbols = {
        attach_mappings = function(buffer)
          vim.keymap.del('i', '<c-space>', { buffer = buffer })
          return true
        end,
      },
      live_grep = {
        attach_mappings = function(buffer)
          vim.keymap.del('i', '<c-space>', { buffer = buffer })
          return true
        end,
      },
      registers = cursor({
        attach_mappings = function(buffer, map)
          vim.keymap.del({ 'i', 'n' }, '<c-e>', { buffer = buffer })
          local r = { '"', '-', '#', '=', '/', '*', '+', ':', '.', '%' }
          for i = 0, 9 do
            table.insert(r, tostring(i))
          end
          for _, key in ipairs(r) do
            map('n', key, {
              function()
                vim.schedule_wrap(u.key.feedkeys)('<cr>', 'm')
                return 'i' .. key
              end,
              type = 'command',
            }, { expr = true })
          end
          return true
        end,
        initial_mode = 'normal',
      }),
      grep_string = { additional_args = additional_args },
      find_files = { prompt_title = 'Find File', find_command = find_command },
    },
    extensions = {
      live_grep_args = {
        auto_quoting = false,
        additional_args = additional_args,
        prompt_title = 'Live Grep Arg',
        mappings = { i = {}, n = {} },
      },
    },
  }
  local t = require('telescope')
  local h = require('handler')
  local a = require('telescope.actions')
  local ag = require('telescope.actions.generate')
  -- stylua: ignore start
  local insert_and_normal = {
    ['<cr>'] = { a.select_default, type = 'action', opts = { desc = 'Select Default' } },
    ['<c-s>'] = { a.select_horizontal, type = 'action', opts = { desc = 'Select Horizontal' } },
    ['<c-v>'] = { a.select_vertical, type = 'action', opts = { desc = 'Select Vertical' } },
    ['<c-t>'] = { a.select_tab, type = 'action', opts = { desc = 'Select Tab' } },
    ['<c-u>'] = { a.preview_scrolling_up, type = 'action', opts = { desc = 'Preview Scroll Up' } },
    ['<c-d>'] = { a.preview_scrolling_down, type = 'action', opts = { desc = 'Preview Scroll Down' } },
    ['<c-j>'] = { a.move_selection_next, type = 'action', opts = { desc = 'Move Selection Next' } },
    ['<c-k>'] = { a.move_selection_previous, type = 'action', opts = { desc = 'Move Selection Previous' } },
    ['<c-q>'] = { a.send_selected_to_qflist + a.open_qflist, type = 'action', opts = { desc = 'Send Selected to Qflist' }, },
    ['<c-l>'] = { a.send_selected_to_loclist + a.open_loclist, type = 'action', opts = { desc = 'Send Selected to Loclist' }, },
    ['<c-f>'] = { h.toggle_live_grep_arg, type = 'action', opts = { desc = 'Toggle Live Grep Arg' } },
    ['<c-p>'] = { h.toggle_find_file, type = 'action', opts = { desc = 'Toggle Find File' } },
    ['<m-f>'] = { h.toggle_find_word, type = 'action', opts = { desc = 'Toogle Find Word' } },
    ['<tab>'] = { a.toggle_selection + a.move_selection_worse, type = 'action', opts = { desc = 'Toggle Selection' } },
    ['<s-tab>'] = { a.move_selection_better + a.toggle_selection, type = 'action', opts = { desc = 'Toggle Selection' }, },
    ['<f1>'] = { ag.which_key({ keybind_width = 14, max_height = 0.25 }), type = 'action', opts = { desc = 'Which Key' } },
    ['<leftmouse>'] = { a.mouse_click, type = 'action', opts = { desc = 'Mouse Click' } },
    ['<2-leftmouse>'] = { a.double_mouse_click, type = 'action', opts = { desc = 'Mouse Double Click' } },
    ['<m-a>'] = { h.smart_select_all, type = 'action', opts = { desc = 'Smart Select All' } },
    ['<m-p>'] = { a.cycle_history_prev, type = 'action', opts = { desc = 'Previous Search History' } },
    ['<m-n>'] = { a.cycle_history_next, type = 'action', opts = { desc = 'Next Search History' } },
  }
  opts.defaults.mappings.n = {
    ['<esc>'] = { a.close, type = 'action', opts = { desc = 'Close' } },
    ['q'] = { a.close, type = 'action', opts = { desc = 'Close' } },
    ['j'] = { a.move_selection_next, type = 'action', opts = { desc = 'Move Selection Next' } },
    ['k'] = { a.move_selection_previous, type = 'action', opts = { desc = 'Move Selection Previous' } },
    ['H'] = { a.move_to_top, type = 'action', opts = { desc = 'Move to Top' } },
    ['M'] = { a.move_to_middle, type = 'action', opts = { desc = 'Move to Middle' } },
    ['L'] = { a.move_to_bottom, type = 'action', opts = { desc = 'Move to Bottom' } },
    ['G'] = { a.move_to_bottom, type = 'action', opts = { desc = 'Move to Bottom' } },
    ['gg'] = { a.move_to_top, type = 'action', opts = { desc = 'Move to Top' } },
  }
  opts.defaults.mappings.i = {
    -- INFO:
    -- Used to delete one word before
    -- See https://github.com/nvim-telescope/telescope.nvim/issues/1579#issuecomment-989767519
    ['<c-w>'] = { '<c-s-w>', type = 'command' },
    ['<c-c>'] = { a.close, type = 'action', opts = { desc = 'Close' } },
    ['<c-r><c-w>'] = { a.insert_original_cword, type = 'action', opts = { desc = 'Insert Cword' } },
    ['<c-r><c-a>'] = { a.insert_original_cWORD, type = 'action', opts = { desc = 'Insert CWORD' } },
    ['<c-r><c-f>'] = { a.insert_original_cfile, type = 'action', opts = { desc = 'Insert Cfile' } },
    ['<c-r><c-l>'] = { a.insert_original_cline, type = 'action', opts = { desc = 'Insert Cline' } },
  }
  -- stylua: ignore end
  opts.defaults.mappings.n = vim.tbl_deep_extend('error', opts.defaults.mappings.n, insert_and_normal)
  opts.defaults.mappings.i = vim.tbl_deep_extend('error', opts.defaults.mappings.i, insert_and_normal)
  local lm = {
    ['<m-s>'] = { h.toggle_quotation_wrap(), type = 'action', opts = { desc = 'Toggle Quotation' } },
    ['<m-i>'] = {
      h.toggle_quotation_wrap({ postfix = ' --iglob=' }),
      type = 'action',
      opts = { desc = 'Toggle iglob' },
    },
  }
  opts.extensions.live_grep_args.mappings.i = lm
  opts.extensions.live_grep_args.mappings.n = lm
  t.setup(opts)
  t.load_extension('fzf')
  t.load_extension('live_grep_args')
  require('telescope-all-recent').setup({})
  vim.api.nvim_create_autocmd('User', {
    pattern = 'TelescopePreviewerLoaded',
    callback = function() vim.wo.wrap = true end,
  })
end

local function load_cp()
  require('competitest').setup({
    testcases_input_file_format = '$(FNOEXT)_$(TCNUM).in',
    testcases_output_file_format = '$(FNOEXT)_$(TCNUM).out',
    compile_command = {
      cpp = { exec = 'g++', args = { '-g', '-Wall', '$(FNAME)', '-o', '$(FNOEXT).out', '-std=c++23' } },
    },
    run_command = { cpp = { exec = './$(FNOEXT).out' } },
    picker_ui = {
      mappings = {
        focus_next = 'j',
        focus_prev = 'k',
        close = { '<esc>', 'q' },
        submit = '<cr>',
      },
    },
    editor_ui = {
      normal_mode_mappings = {
        switch_window = {},
        save_and_close = { '<c-s>', '<m-s>' },
        cancel = { '<esc>', 'q' },
      },
      insert_mode_mappings = {
        switch_window = {},
        save_and_close = { '<c-s>', '<m-s>' },
        cancel = { '<c-c>' },
      },
    },
    runner_ui = {
      interface = 'split',
      mappings = {
        run_again = 'r',
        run_all_again = 'R',
        kill = '<c-c>',
        kill_all = {},
        view_input = 'i',
        view_output = 'a',
        view_stdout = 'o',
        view_stderr = 'e',
        toggle_diff = 'd',
        close = { 'q', '<esc>' },
      },
    },
    template_file = { cpp = vim.fn.stdpath('config') .. '/cp/template.cpp' },
    evaluate_template_modifiers = true,
    received_problems_path = function(task, file_ext)
      local sub_dir
      local filename = 'unknown'
      if task.url:find('codeforces') then
        sub_dir = 'CodeForces'
        ---@diagnostic disable-next-line: unbalanced-assignments
        local number, letter = task.url:match('/problemset/problem/(%d+)/([A-Z]+)')
          or task.url:match('/contest/(%d+)/problem/([A-Z]+)')
        if number and letter then filename = number .. letter end
      elseif task.url:find('luogu') then
        sub_dir = 'Luogu'
        local id = task.url:match('/problem/([A-Za-z0-9]+)')
        if id then filename = id end
      elseif task.url:find('leetcode') then
        sub_dir = 'LeetCode'
      elseif task.url:find('uva') then
        sub_dir = 'UVa'
        local id = task.url:match('UVA%-?(%d+)')
        if id then filename = id end
      else
        sub_dir = 'Other'
      end

      return vim.fn.getcwd() .. '/' .. sub_dir .. '/' .. filename .. '.' .. file_ext
    end,
  })
end

load_conform()
if vim.fn.executable('tree-sitter') == 1 then load_treesitter() end
load_lspconfig()
load_mason()
load_treesitter_textobjects()
load_nvim_tree()
load_telescope()
load_cp()
