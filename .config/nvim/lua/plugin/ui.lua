local u = require('utils')

local function load_context()
  require('treesitter-context').setup({
    max_liens = math.max(vim.o.scrolloff, 5),
    on_attach = function(buffer) return not u.buffer.big(buffer) end,
  })
end

local function ui_input_on_init(uiinput, opt, on_done)
  local event = require('nui.utils.autocmd').event
  local prompt = opt.prompt or ''
  local default = opt.default or ''
  local should_be_normal = (
    prompt:find('Copy to')
    or prompt:find('Move to')
    or prompt:find('Rename')
    or prompt:find('Remove')
    or prompt:find('New Name')
  ) and default:sub(-1) ~= '/'
  uiinput:on(event.BufLeave, function() uiinput:unmount() end, { once = true })
  uiinput:map('n', 'q', function() on_done(nil) end, { noremap = true, nowait = true })
  uiinput:map('n', '<Esc>', function() on_done(nil) end, { noremap = true, nowait = true })
  uiinput:map('i', '<c-c>', function() on_done(nil) end, { noremap = true, nowait = true })
  uiinput:map('i', '<c-w>', '<c-s-w>', { noremap = true, nowait = true })
  uiinput:on(event.BufEnter, function()
    if should_be_normal then
      vim.cmd('stopinsert | norm! 0')
    else
      vim.cmd('startinsert!')
    end
  end, { once = true })
  if prompt:find('[yY]es') or prompt:find('[yY]/[nN]') then
    uiinput:map('n', 'y', function() on_done('y') end, { noremap = true, nowait = true })
    uiinput:map('n', 'Y', function() on_done('Y') end, { noremap = true, nowait = true })
  end
  if prompt:find('[nN]o') or prompt:find('[yY]/[nN]') then
    uiinput:map('n', 'n', function() on_done('n') end, { noremap = true, nowait = true })
    uiinput:map('n', 'N', function() on_done('N') end, { noremap = true, nowait = true })
  end
end

---@diagnostic disable-next-line: unused-local
local function ui_select_on_init(uiselect, items, opts, on_done)
  local event = require('nui.utils.autocmd').event
  uiselect:on(event.BufLeave, function() uiselect:unmount() end, { once = true })
  uiselect:map('n', 'q', function() on_done(nil, nil) end, { noremap = true, nowait = true })
  uiselect:map('n', '<Esc>', function() on_done(nil, nil) end, { noremap = true, nowait = true })
  if #items <= 10 then
    for i = 1, math.min(10, #items) do
      uiselect:map('n', tostring(i % 10), function() on_done(items[i], i) end, { noremap = true, nowait = true })
    end
  end
end

local function load_lualine()
  require('lualine').setup({
    options = {
      globalstatus = true,
      always_divide_middle = true,
      disabled_filetypes = {
        winbar = {
          'dapui_console',
          'dapui_stacks',
          'dapui_watches',
          'dapui_breakpoints',
          'dapui_hover',
          'dap-repl',
          'dap-view',
          'dap-view-term',
          'dap-view-help',
        },
      },
      ignore_focus = { 'CompetiTest' },
    },
    inactive_winbar = {
      lualine_a = {
        {
          '%=',
          cond = function() return vim.bo.filetype == 'CompetiTest' end,
          color = 'WinBarNC',
        },
        {
          function() return vim.b.competitest_title or 'CompetiTest' end,
          cond = function() return vim.bo.filetype == 'CompetiTest' end,
          color = 'lualine_a_normal',
        },
        {
          '%=',
          cond = function() return vim.bo.filetype == 'CompetiTest' end,
          color = 'WinBarNC',
        },
      },
    },
    sections = {
      lualine_c = { 'filename', 'filesize' },
      lualine_x = { 'lsp_status', 'encoding', 'fileformat', 'filetype' },
    },
  })
end

local function load_todo_comments() require('todo-comments').setup({ sign_priority = 1 }) end

local function load_blink_indent()
  -- BUG: https://github.com/saghen/blink.indent/issues/47
  require('blink.indent').setup({
    mappings = {
      object_scope = '',
      object_scope_with_border = '',
      goto_top = '',
      goto_bottom = '',
    },
    static = {
      whitespace_char = '·',
      char = '│',
    },
    scope = {
      enabled = true,
      char = '│',
      priority = 1000,
      highlights = {
        'BlinkIndentRed',
        'BlinkIndentOrange',
        'BlinkIndentYellow',
        'BlinkIndentGreen',
        'BlinkIndentBlue',
        'BlinkIndentCyan',
        'BlinkIndentViolet',
      },
      underline = {
        enabled = true,
        highlights = {
          'BlinkIndentRedUnderline',
          'BlinkIndentOrangeUnderline',
          'BlinkIndentYellowUnderline',
          'BlinkIndentGreenUnderline',
          'BlinkIndentBlueUnderline',
          'BlinkIndentCyanUnderline',
          'BlinkIndentVioletUnderline',
        },
      },
    },
  })
end

local function get_prompt_text(prompt, default_prompt)
  local prompt_text = prompt or default_prompt
  if prompt_text:sub(-1) == ':' then prompt_text = '[' .. prompt_text:sub(1, -2) .. ']' end
  return prompt_text
end

local function override_ui_select()
  local Menu = require('nui.menu')
  local UISelect = Menu:extend('UISelect')

  function UISelect:init(items, opts, on_done)
    local border_top_text = get_prompt_text(opts.prompt, '[Select Item]')
    local kind = opts.kind or 'unknown'
    local format_item = opts.format_item or function(item) return tostring(item.__raw_item or item) end

    local popup_options = {
      relative = 'editor',
      position = '50%',
      border = { style = 'rounded', text = { top = border_top_text, top_align = 'left' } },
      win_options = { winhighlight = 'NormalFloat:Normal,FloatBorder:Normal' },
      zindex = 999,
    }

    if kind == 'codeaction' then
      -- change position for codeaction selection
      popup_options.relative = 'cursor'
      popup_options.position = { row = 2, col = 0 }
    end

    local max_width = popup_options.relative == 'editor' and vim.o.columns - 4 or vim.api.nvim_win_get_width(0) - 4
    local max_height = popup_options.relative == 'editor' and math.floor(vim.o.lines * 80 / 100)
      or vim.api.nvim_win_get_height(0)

    local menu_items = {}
    for index, item in ipairs(items) do
      local item_text = string.sub(format_item(item), 0, max_width)
      if not item_text:match('%d+%. ') then item_text = string.format('%d. %s', index, item_text):sub(0, max_width) end
      if type(item) ~= 'table' then item = { __raw_item = item } end
      item.index = index
      menu_items[index] = Menu.item(item_text, item)
    end

    local menu_options = {
      min_width = vim.api.nvim_strwidth(border_top_text),
      max_width = max_width,
      max_height = max_height,
      lines = menu_items,
      on_close = function() on_done(nil, nil) end,
      on_submit = function(item) on_done(item.__raw_item or item, item.index) end,
    }

    UISelect.super.init(self, popup_options, menu_options)
    ui_select_on_init(self, items, opts, on_done)
  end

  local select_ui = nil

  vim.ui.select = function(items, opts, on_choice)
    assert(type(on_choice) == 'function', 'missing on_choice function')

    if select_ui then
      -- ensure single ui.select operation
      vim.notify('Another select is pending, please finish it first.', vim.log.levels.ERROR, { title = 'Light Boat' })
      return
    end

    select_ui = UISelect(items, opts, function(item, index)
      if select_ui then
        -- if it's still mounted, unmount it
        select_ui:unmount()
      end
      -- pass the select value
      on_choice(item, index)
      -- indicate the operation is done
      select_ui = nil
    end)

    select_ui:mount()
  end
end

local function override_ui_input()
  local Input = require('nui.input')
  local UIInput = Input:extend('UIInput')
  function UIInput:init(opts, on_done)
    local border_top_text = get_prompt_text(opts.prompt, '[Input]')
    local default_value = tostring(opts.default or '')
    UIInput.super.init(self, {
      relative = 'cursor',
      position = { row = 2, col = 0 },
      size = { width = math.floor(math.max(40, 1.5 * vim.api.nvim_strwidth(default_value))) },
      border = { style = vim.o.winborder, text = { top = border_top_text, top_align = 'left' } },
      win_options = { winhighlight = 'NormalFloat:Normal,FloatBorder:Normal' },
    }, {
      default_value = default_value,
      on_close = function() on_done(nil) end,
      on_submit = function(value) on_done(value) end,
    })
    ui_input_on_init(self, opts, on_done)
  end
  local input_ui
  vim.ui.input = function(opts, on_confirm)
    assert(type(on_confirm) == 'function', 'missing on_confirm function')

    if input_ui then
      vim.notify('Another input is pending, please finish it first.', vim.log.levels.ERROR, { title = 'Light Boat' })
      return
    end

    input_ui = UIInput(opts, function(value)
      if input_ui then
        -- if it's still mounted, unmount it
        input_ui:unmount()
      end
      -- pass the input value
      on_confirm(value)
      -- indicate the operation is done
      input_ui = nil
    end)

    input_ui:mount()
  end
end

local function load_nui()
  override_ui_input()
  override_ui_select()
end

load_context()
load_lualine()
load_todo_comments()
load_blink_indent()
load_nui()
