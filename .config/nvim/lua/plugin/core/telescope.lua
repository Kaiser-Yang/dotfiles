local u = require('utils')
u.gh('nvim-lua/plenary.nvim')
u.gh('nvim-telescope/telescope-live-grep-args.nvim')
u.gh('nvim-telescope/telescope-fzf-native.nvim')
u.gh('nvim-telescope/telescope.nvim')
u.gh('kkharji/sqlite.lua')
u.gh('prochri/telescope-all-recent.nvim')

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
    lsp_document_symbols = ivy(),
    lsp_dynamic_workspace_symbols = ivy(),
    lsp_references = cursor(),
    lsp_implementations = cursor(),
    lsp_incoming_calls = cursor(),
    lsp_outgoing_calls = cursor(),
    lsp_type_definitions = cursor(),
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
              vim.schedule_wrap(u.key.feed)('<cr>', 'm')
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
local insert_and_normal = {
  ['<cr>'] = { a.select_default, type = 'action', opts = { desc = 'Select Default' } },
  ['<c-s>'] = { a.select_horizontal, type = 'action', opts = { desc = 'Select Horizontal' } },
  ['<c-v>'] = { a.select_vertical, type = 'action', opts = { desc = 'Select Vertical' } },
  ['<c-t>'] = { a.select_tab, type = 'action', opts = { desc = 'Select Tab' } },
  ['<c-u>'] = { a.preview_scrolling_up, type = 'action', opts = { desc = 'Preview Scroll Up' } },
  ['<c-d>'] = { a.preview_scrolling_down, type = 'action', opts = { desc = 'Preview Scroll Down' } },
  ['<c-j>'] = { a.move_selection_next, type = 'action', opts = { desc = 'Move Selection Next' } },
  ['<c-k>'] = { a.move_selection_previous, type = 'action', opts = { desc = 'Move Selection Previous' } },
  ['<c-q>'] = {
    a.send_selected_to_qflist + a.open_qflist,
    type = 'action',
    opts = { desc = 'Send Selected to Qflist' },
  },
  ['<c-l>'] = {
    a.send_selected_to_loclist + a.open_loclist,
    type = 'action',
    opts = { desc = 'Send Selected to Loclist' },
  },
  ['<c-f>'] = { h.telescope.toggle_live_grep, type = 'action', opts = { desc = 'Toggle Live Grep Arg' } },
  ['<c-p>'] = { h.telescope.toggle_find_file, type = 'action', opts = { desc = 'Toggle Find File' } },
  ['<m-f>'] = { h.telescope.toggle_find_word, type = 'action', opts = { desc = 'Toogle Find Word' } },
  ['<m-a>'] = { h.telescope.smart_select_all, type = 'action', opts = { desc = 'Smart Select All' } },
  ['<m-s>'] = { h.telescope.toggle_quotation, type = 'action', opts = { desc = 'Toggle Quotation' } },
  ['<tab>'] = { a.toggle_selection + a.move_selection_worse, type = 'action', opts = { desc = 'Toggle Selection' } },
  ['<s-tab>'] = { a.move_selection_better + a.toggle_selection, type = 'action', opts = { desc = 'Toggle Selection' } },
  ['<leftmouse>'] = { a.mouse_click, type = 'action', opts = { desc = 'Mouse Click' } },
  ['<2-leftmouse>'] = { a.double_mouse_click, type = 'action', opts = { desc = 'Mouse Double Click' } },
  ['<m-p>'] = { a.cycle_history_prev, type = 'action', opts = { desc = 'Previous Search History' } },
  ['<m-n>'] = { a.cycle_history_next, type = 'action', opts = { desc = 'Next Search History' } },
  ['<c-space>'] = { a.to_fuzzy_refine, type = 'action', opts = { desc = 'Freeze for Fuzzy Refine' } },
  ['<c-c>'] = { a.close, type = 'action', opts = { desc = 'Close' } },
  ['<f1>'] = { ag.which_key({ keybind_width = 14, max_height = 0.25 }), type = 'action', opts = { desc = 'Which Key' } },
}
opts.defaults.mappings.n = {
  ['j'] = { a.move_selection_next, type = 'action', opts = { desc = 'Move Selection Next' } },
  ['k'] = { a.move_selection_previous, type = 'action', opts = { desc = 'Move Selection Previous' } },
  ['H'] = { a.move_to_top, type = 'action', opts = { desc = 'Move to Top' } },
  ['gg'] = { a.move_to_top, type = 'action', opts = { desc = 'Move to Top' } },
  ['M'] = { a.move_to_middle, type = 'action', opts = { desc = 'Move to Middle' } },
  ['L'] = { a.move_to_bottom, type = 'action', opts = { desc = 'Move to Bottom' } },
  ['G'] = { a.move_to_bottom, type = 'action', opts = { desc = 'Move to Bottom' } },
  ['q'] = { a.close, type = 'action', opts = { desc = 'Close' } },
  ['<esc>'] = { a.close, type = 'action', opts = { desc = 'Close' } },
}
opts.defaults.mappings.i = {
  ['<c-w>'] = { '<c-s-w>', type = 'command' },
  ['<c-r><c-w>'] = { a.insert_original_cword, type = 'action', opts = { desc = 'Insert Cword' } },
  ['<c-r><c-a>'] = { a.insert_original_cWORD, type = 'action', opts = { desc = 'Insert CWORD' } },
  ['<c-r><c-f>'] = { a.insert_original_cfile, type = 'action', opts = { desc = 'Insert Cfile' } },
  ['<c-r><c-l>'] = { a.insert_original_cline, type = 'action', opts = { desc = 'Insert Cline' } },
}
opts.defaults.mappings.n = vim.tbl_deep_extend('error', opts.defaults.mappings.n, insert_and_normal)
opts.defaults.mappings.i = vim.tbl_deep_extend('error', opts.defaults.mappings.i, insert_and_normal)
t.setup(opts)
t.load_extension('fzf')
t.load_extension('live_grep_args')
require('telescope-all-recent').setup({})
