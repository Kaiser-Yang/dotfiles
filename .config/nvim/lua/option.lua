--- @class LightBoat.Opt
vim.g.lightboat_opt = {
  -- In most cases, we do not need to listen on "TextChanged" and "TextChangedI",
  -- If your file grows to big or shrinks to small,
  -- you just need to run ":e" to make LightBoat re-detect
  --- @type string[]|string
  big_file_detection = { 'BufReadPre', 'FileType', 'BufReadPost' },
  --- @type string[]
  treesitter_ensure_installed = {},
  --- @type string[]
  mason_ensure_installed = { 'lua-language-server', 'stylua' },
  override_ui_input = true,
  override_ui_select = true,
  ui_input_on_init = function(uiinput, opt, on_done)
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
    local should_map_y_and_n = prompt:find('[yY]es/[nN]o') or prompt:find('[yY]/[nN]')
    uiinput:on(event.BufLeave, function() on_done(nil) end, { once = true })
    uiinput:map('n', 'q', function() on_done(nil) end, { noremap = true, nowait = true })
    uiinput:map('n', '<Esc>', function() on_done(nil) end, { noremap = true, nowait = true })
    uiinput:map('n', '<c-c>', function() on_done(nil) end, { noremap = true, nowait = true })
    uiinput:map('i', '<c-c>', function() on_done(nil) end, { noremap = true, nowait = true })
    uiinput:on(event.BufEnter, function()
      local mode = vim.fn.mode('1')
      if mode == 'n' and should_be_normal or mode ~= 'n' and not should_be_normal then return end
      vim.cmd('stopinsert | norm! 0')
    end, { once = true })
    if should_map_y_and_n then
      uiinput:map('n', 'y', function() on_done('y') end, { noremap = true, nowait = true })
      uiinput:map('n', 'Y', function() on_done('Y') end, { noremap = true, nowait = true })
      uiinput:map('n', 'n', function() on_done('n') end, { noremap = true, nowait = true })
      uiinput:map('n', 'N', function() on_done('N') end, { noremap = true, nowait = true })
    end
  end,
  ---@diagnostic disable-next-line: unused-local
  ui_select_on_init = function(uiselect, items, opts, on_done)
    local event = require('nui.utils.autocmd').event
    uiselect:on(event.BufLeave, function() on_done(nil, nil) end, { once = true })
    uiselect:map('n', 'q', function() on_done(nil, nil) end, { noremap = true, nowait = true })
    uiselect:map('n', '<Esc>', function() on_done(nil, nil) end, { noremap = true, nowait = true })
    uiselect:map('n', '<c-c>', function() on_done(nil, nil) end, { noremap = true, nowait = true })
    if #items <= 10 then
      for i = 1, math.min(10, #items) do
        uiselect:map('n', tostring(i % 10), function() on_done(items[i], i) end, { noremap = true, nowait = true })
      end
    end
  end,
}
vim.g.blink_cmp_unique_priority = function(ctx)
  if ctx.mode == 'cmdline' then
    return { 'cmdline', 'path', 'buffer' }
  else
    return { 'snippets', 'lsp', 'ripgrep', 'dictionary', 'buffer' }
  end
end
vim.g.highlight_on_yank = true
vim.g.highlight_on_yank_limit = 1024 * 1024 -- 1 MB
vim.g.highlight_on_yank_duration = 300 -- Unit: ms
vim.g.conform_on_save = true
vim.g.conform_on_save_reguess_indent = true
vim.g.conform_formatexpr_auto_set = true
vim.g.treesitter_indentexpr_auto_set = true
vim.g.treesitter_highlight_auto_start = true
vim.g.treesitter_foldexpr_auto_set = true
vim.g.nohlsearch_auto_run = true
vim.g.big_file_limit = 1024 * 1024 -- 1 MB
vim.g.big_file_average_every_line = 200 -- Unit: B
local original = {}
vim.g.big_file_callback = function(data)
  if not original[data.buffer] then original[data.buffer] = {} end
  if
    not original[data.buffer].indentexpr
    and vim.bo.indentexpr ~= ''
    and vim.bo.indentexpr ~= "v:lua.require'nvim-treesitter'.indentexpr()"
  then
    original[data.buffer].indentexpr = vim.bo.indentexpr
  end
  if data.new_status and vim.bo.filetype ~= '' and not vim.bo.filetype:find('bigfile') then
    vim.cmd('noautocmd setlocal filetype=' .. vim.bo.filetype .. 'bigfile')
  end
  if data.new_status == data.old_status then return end
  if data.new_status then
    vim.b.conform_on_save = false
    vim.b.treesitter_foldexpr_auto_set = false
    vim.b.treesitter_indentexpr_auto_set = false
    vim.b.treesitter_highlight_auto_start = false
    vim.bo.indentexpr = original[data.buffer].indentexpr or ''
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == data.buffer then
        vim.wo[win][0].foldmethod = 'manual'
        vim.wo[win][0].foldexpr = '0'
      end
    end
    for _, client in pairs(vim.lsp.get_clients({ bufnr = data.buffer })) do
      vim.lsp.buf_detach_client(data.buffer, client.id)
    end
    if vim.treesitter.highlighter.active[data.buffer] ~= nil then vim.treesitter.stop(data.buffer) end
    if _G.plugin_loaded['nvim-treesitter-endwise'] then require('nvim-treesitter.endwise').detach(data.buffer) end
    -- Using enable here will automatically disable context for big files
    if _G.plugin_loaded['nvim-treesitter-context'] then require('treesitter-context').enable() end
  else
    vim.b.conform_on_save = nil
    vim.b.treesitter_foldexpr_auto_set = nil
    vim.b.treesitter_indentexpr_auto_set = nil
    vim.b.treesitter_highlight_auto_start = nil
    -- Trigger the FileType autocommand to let LSP, indentexpr, endwise and foldexpr set up
    if vim.bo.filetype ~= '' then vim.bo.filetype = vim.bo.filetype:gsub('bigfile', '') end
    if _G.plugin_loaded['nvim-treesitter-context'] then require('treesitter-context').enable() end
  end
end

-- Disable entire built-in ftplugin mappings to avoid conflicts.
-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
vim.g.no_plugin_maps = true

-- We use another explorer instead of netrw, so disable it
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '
vim.o.numberwidth = 1
vim.o.winborder = 'rounded'
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes:1'
vim.o.jumpoptions = 'stack'
vim.o.termguicolors = true
vim.o.scrolloff = 5
vim.o.colorcolumn = '100'
vim.o.cursorline = true
vim.o.list = true
vim.o.listchars = 'tab:»-,trail:·,lead:·'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.foldopen = 'block,mark,percent,quickfix,search,tag,undo'
vim.o.foldlevel = 99999
vim.o.foldcolumn = '1'
vim.o.fillchars = 'fold: ,foldopen:,foldclose:,foldsep: '
vim.o.splitright = true
vim.o.splitbelow = false
vim.o.autowriteall = true
vim.o.cmdwinheight = 10
vim.o.nrformats = 'bin,hex,octal'

vim.filetype.add({ pattern = { ['.*.bazelrc'] = 'bazelrc' } })
vim.treesitter.language.register('objc', { 'objcpp' })
vim.diagnostic.config({
  virtual_lines = { current_line = true },
})
