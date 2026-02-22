-- WARN:
-- Do not modify the prompt_title of any existed picker
-- BUG:
-- https://github.com/nvim-telescope/telescope.nvim/issues/3621
return {
  'nvim-telescope/telescope.nvim',
  opts = {
    defaults = { mappings = { n = {}, i = {} } },
    pickers = {
      registers = {
        attach_mappings = function(buffer, map)
          local u = require('lightboat.util')
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
      },
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
    },
    extensions = { live_grep_args = { mappings = { i = {}, n = {} } } },
  },
  config = function(_, opts)
    local t = require('telescope')
    local h = require('lightboat.handler')
    local a = require('telescope.actions')
    local ag = require('telescope.actions.generate')
    -- stylua: ignore start
    local insert_and_normal = {
      ['<cr>'] = { a.select_default, type = 'action', opts = { desc = 'Select Default' } },
      ['<c-c>'] = { a.close, type = 'action', opts = { desc = 'Close' } },
      ['<c-s>'] = { a.select_horizontal, type = 'action', opts = { desc = 'Select Horizontal' } },
      ['<c-v>'] = { a.select_vertical, type = 'action', opts = { desc = 'Select Vertical' } },
      ['<c-t>'] = { a.select_tab, type = 'action', opts = { desc = 'Select Tab' } },
      ['<c-u>'] = { a.preview_scrolling_up, type = 'action', opts = { desc = 'Preview Scroll Up' } },
      ['<c-d>'] = { a.preview_scrolling_down, type = 'action', opts = { desc = 'Preview Scroll Down' } },
      ['<c-j>'] = { a.move_selection_next, type = 'action', opts = { desc = 'Move Selection Next' } },
      ['<c-k>'] = { a.move_selection_previous, type = 'action', opts = { desc = 'Move Selection Previous' } },
      ['<c-q>'] = { a.send_selected_to_qflist + a.open_qflist, type = 'action', opts = { desc = 'Send Selected to Qflist' }, },
      ['<c-l>'] = { a.send_selected_to_loclist + a.open_loclist, type = 'action', opts = { desc = 'Send Selected to Loclist' }, },
      ['<c-f>'] = { h.toggle_live_grep_frecency, type = 'action', opts = { desc = 'Toggle Live Grep Frecency' } },
      ['<c-p>'] = { h.toggle_frecency, type = 'action', opts = { desc = 'Toggle Find File Frecency' } },
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
  end,
}
