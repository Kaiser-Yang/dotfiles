local u = require('utils')

vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Build plugins when changed',
  group = _G.autocmd_group,
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name ~= 'nvim-treesitter' or kind == 'update' then
      if not ev.data.active then vim.cmd.packadd(name) end
      u.build_plugin(name)
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufReadPre', 'FileType', 'BufReadPost' }, {
  desc = 'Disable features for big files',
  group = _G.autocmd_group,
  callback = function(ev)
    local old_status = vim.b.big_file_status or false
    vim.b.big_file_status = u.buffer.big(ev.buf, ev.event)
    local new_status = vim.b.big_file_status
    local bufnr = ev.buf
    if new_status and vim.bo.filetype ~= '' and not vim.bo.filetype:find('bigfile') then
      vim.cmd('noautocmd setlocal filetype=' .. vim.bo.filetype .. 'bigfile')
    end
    if new_status == old_status then return end
    if new_status then
      vim.b.blink_pairs = false
      vim.b.conform_on_save = false
      vim.b.treesitter_foldexpr_auto_set = false
      vim.b.treesitter_highlight_auto_start = false
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == bufnr then
          vim.wo[win][0].foldmethod = 'manual'
          vim.wo[win][0].foldexpr = '0'
        end
      end
      for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        vim.lsp.buf_detach_client(bufnr, client.id)
      end
      if vim.treesitter.highlighter.active[bufnr] ~= nil then vim.treesitter.stop(bufnr) end
      if _G.loaded['nvim-treesitter-endwise'] then require('nvim-treesitter.endwise').detach(bufnr) end
      -- Using enable here will automatically disable context for big files
      if _G.loaded['nvim-treesitter-context'] then require('treesitter-context').enable() end
    else
      vim.b.blink_pairs = nil
      vim.b.conform_on_save = nil
      vim.b.treesitter_foldexpr_auto_set = nil
      vim.b.treesitter_highlight_auto_start = nil
      -- Trigger the FileType autocommand to let LSP, indentexpr, endwise and foldexpr set up
      vim.bo.filetype = vim.bo.filetype:gsub('bigfile', '')
      if _G.loaded['nvim-treesitter-context'] then require('treesitter-context').enable() end
    end
  end,
})

-- INFO:
-- In vim, copying with named registers will change the unnamed registers
-- We use these two auto commands here to prevent this.
local unnamed_reg_content
local unnamed_reg_type
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Store the unnamed register after entering',
  group = _G.autocmd_group,
  callback = function()
    unnamed_reg_content = vim.fn.getreg('"')
    unnamed_reg_type = vim.fn.getregtype('"')
  end,
  once = true,
})
vim.schedule_wrap(vim.api.nvim_create_autocmd)('TextYankPost', {
  desc = 'Store or restore the unnamed register',
  group = _G.autocmd_group,
  callback = function()
    if vim.v.event.regname ~= '' and vim.v.event.regname ~= '"' then
      vim.fn.setreg('"', unnamed_reg_content, unnamed_reg_type)
    else
      unnamed_reg_content = vim.fn.getreg('"')
      unnamed_reg_type = vim.fn.getregtype('"')
    end
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('ModeChanged', {
  desc = 'Disable hlsearch when leaving normal mode',
  group = _G.autocmd_group,
  callback = function()
    if u.in_macro_executing() then return end
    ---@diagnostic disable-next-line: undefined-field
    local new = vim.v.event.new_mode
    if new ~= 'n' then vim.schedule_wrap(vim.cmd.nohlsearch)() end
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('ModeChanged', {
  desc = 'Disable diagnostic when leaving normal; enable otherwise',
  group = _G.autocmd_group,
  callback = function()
    if u.in_macro_executing() then return end
    ---@diagnostic disable-next-line: undefined-field
    local new = vim.v.event.new_mode
    local status = new == 'n'
    local bufnr = vim.api.nvim_get_current_buf()
    if status == vim.diagnostic.is_enabled({ bufnr = bufnr }) then return end
    vim.diagnostic.enable(status, { bufnr = bufnr })
  end,
})

local limit = 1024 * 1024 -- 1 MB
local timeout = 300 -- Unit: ms
vim.schedule_wrap(vim.api.nvim_create_autocmd)('TextYankPost', {
  desc = 'Highlight after yanking',
  group = _G.autocmd_group,
  callback = function()
    assert(vim.v.event.regcontents)
    local size = 0
    local should_hl = nil
    ---@diagnostic disable-next-line: param-type-mismatch
    for _, line in ipairs(vim.v.event.regcontents) do
      size = size + #line
      if limit == nil and size > 0 then
        should_hl = true
        break
      elseif size > limit then
        should_hl = false
        break
      end
    end
    if should_hl == nil then should_hl = size > 0 end
    if should_hl then vim.hl.on_yank({ timeout = timeout }) end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable some treesitter features',
  group = _G.autocmd_group,
  callback = vim.schedule_wrap(function(ev)
    if not vim.api.nvim_buf_is_valid(ev.buf) then return end
    if
      u.enabled('treesitter_highlight_auto_start')
      and u.treesitter_available(ev.buf, 'highlights')
      -- INFO:
      -- c, lua, markdown, help, vim and query files will be started by neovim automatically
      and not vim.tbl_contains({ 'c', 'lua', 'markdown', 'help', 'vim', 'query' }, vim.bo[ev.buf].filetype)
    then
      vim.treesitter.start(ev.buf)
    end
    if u.enabled('treesitter_foldexpr_auto_set') and u.treesitter_available(ev.buf, 'folds') then
      vim.wo[0][0].foldmethod = 'expr'
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
  end),
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('LspAttach', {
  desc = 'Enable some LSP features',
  group = _G.autocmd_group,
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local highlight_augroup, lightbulb_augroup
    if client and client:supports_method('textDocument/documentHighlight', ev.buf) then
      highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd('CursorHold', {
        desc = 'LSP document highlight',
        group = highlight_augroup,
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.clear_references()
          vim.lsp.buf.document_highlight()
        end,
      })
      vim.api.nvim_create_autocmd({ 'CursorMovedI', 'CursorMovedC', 'CursorMoved', 'ModeChanged', 'BufLeave' }, {
        desc = 'Clear LSP document highlight',
        group = highlight_augroup,
        buffer = ev.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
    if _G.loaded['nvim-lightbulb'] and client and client:supports_method('textDocument/codeAction', ev.buf) then
      lightbulb_augroup = vim.api.nvim_create_augroup('nvim-lightbulb', { clear = false })
      vim.api.nvim_create_autocmd('CursorHold', {
        desc = 'LSP code action lightbulb',
        group = lightbulb_augroup,
        buffer = ev.buf,
        callback = require('nvim-lightbulb').update_lightbulb,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'ModeChanged', 'BufLeave' }, {
        desc = 'Clear LSP code action lightbulb',
        group = lightbulb_augroup,
        buffer = ev.buf,
        callback = function(ev2) require('nvim-lightbulb').clear_lightbulb(ev2.buf) end,
      })
    end
    if _G.loaded['conform.nvim'] then vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end
    vim.api.nvim_create_autocmd('LspDetach', {
      desc = 'Clear LSP auto commands',
      group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
      callback = function(ev2)
        if highlight_augroup then
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = ev2.buf })
        end
        if lightbulb_augroup then
          require('nvim-lightbulb').clear_lightbulb(ev2.buf)
          vim.api.nvim_clear_autocmds({ group = lightbulb_augroup, buffer = ev2.buf })
        end
      end,
    })
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)({ 'FocusLost', 'BufLeave' }, {
  desc = 'Save on leaving',
  group = _G.autocmd_group,
  callback = function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if u.buffer.normal(bufnr) and vim.bo[bufnr].modified then
        vim.api.nvim_buf_call(bufnr, function() vim.cmd('silent update') end)
      end
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Guess indent for files',
  group = _G.autocmd_group,
  callback = vim.schedule_wrap(function(ev)
    if not u.buffer.normal(ev.buf) or not _G.loaded['guess-indent.nvim'] then return end
    require('guess-indent').set_from_buffer(ev.buf, true, true)
  end),
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('BufWritePre', {
  desc = 'Format on save',
  group = _G.autocmd_group,
  callback = function(ev)
    if not u.enabled('conform_on_save') then return end
    require('handler').format({ bufnr = ev.buf, async = false })
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('User', {
  desc = 'Set wrap for telescope',
  group = _G.autocmd_group,
  pattern = 'TelescopePreviewerLoaded',
  callback = function() vim.wo.wrap = true end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Store live grep args',
  group = _G.autocmd_group,
  pattern = 'TelescopePrompt',
  callback = function() _G.last_args = nil end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('QuitPre', {
  desc = 'Quit when there is only nvim-tree',
  group = _G.autocmd_group,
  nested = false,
  callback = function(ev)
    if not _G.loaded['nvim-tree.lua'] then return end

    local tree = require('nvim-tree.api').tree
    if not tree.is_visible() then return end

    local winCount = 0
    local lastWinId
    for _, winId in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winId).focusable then
        local buf = vim.api.nvim_win_get_buf(winId)
        if vim.bo[buf].filetype ~= 'NvimTree' then
          lastWinId = winId
          winCount = winCount + 1
        end
      end
    end

    if ev.event == 'QuitPre' and winCount == 1 and lastWinId == vim.api.nvim_get_current_win() then
      if #vim.api.nvim_list_tabpages() == 1 then
        vim.api.nvim_cmd({ cmd = 'qall' }, {})
      else
        vim.api.nvim_cmd({ cmd = 'tabclose' }, {})
      end
    end
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)({ 'BufWinEnter', 'BufEnter' }, {
  desc = 'Set winbar for competitest windows',
  group = _G.autocmd_group,
  callback = function(ev)
    if vim.bo[ev.buf].filetype ~= 'CompetiTest' then return end
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == ev.buf then
        vim.wo[win][0].signcolumn = 'no'
        vim.wo[win][0].statuscolumn = '%l '
        vim.wo[win][0].winbar = table.concat({
          '%#WinBarNC#',
          '%=',
          '%#lualine_a_normal#',
          vim.b[ev.buf].competitest_title or 'CompetiTest',
          '%#WinBarNC#',
          '%=',
          '%*',
        })
      end
    end
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('WinNew', {
  desc = 'Resize nvim-tree when there is only nvim-tree',
  group = _G.autocmd_group,
  callback = function()
    if not _G.loaded['nvim-tree.lua'] then return end
    local tree = require('nvim-tree.api').tree
    if not tree.is_visible() then return end
    local normal_win_count = 0
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_config(win).relative == '' then
        normal_win_count = normal_win_count + 1
      end
    end
    if normal_win_count == 2 then vim.cmd('NvimTreeResize 35') end
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  desc = "Record last file's name",
  group = _G.autocmd_group,
  callback = function()
    if vim.bo.filetype == 'NvimTree' or vim.api.nvim_buf_get_name(0) == '' then return end
    _G.last_filename = vim.api.nvim_buf_get_name(0)
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Set winfixbuf for some windows',
  group = _G.autocmd_group,
  callback = function(ev)
    if vim.tbl_contains({ 'dap-view', 'NvimTree', 'CompetiTest' }, vim.bo[ev.buf].filetype) then
      vim.wo[0][0].winfixbuf = true
    end
  end,
})
