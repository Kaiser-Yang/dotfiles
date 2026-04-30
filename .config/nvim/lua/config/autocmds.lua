local u = require('utils')

vim.api.nvim_create_autocmd({ 'BufReadPre', 'FileType', 'BufReadPost' }, {
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
      local plugin = vim.pack.get({ 'nvim-treesitter-endwise' })
      if #plugin > 0 and plugin[1].active then require('nvim-treesitter.endwise').detach(bufnr) end
      plugin = vim.pack.get({ 'nvim-treesitter-context' })
      -- Using enable here will automatically disable context for big files
      if #plugin > 0 and plugin[1].active then require('treesitter-context').enable() end
    else
      vim.b.blink_pairs = nil
      vim.b.conform_on_save = nil
      vim.b.treesitter_foldexpr_auto_set = nil
      vim.b.treesitter_highlight_auto_start = nil
      -- Trigger the FileType autocommand to let LSP, indentexpr, endwise and foldexpr set up
      vim.bo.filetype = vim.bo.filetype:gsub('bigfile', '')
      local plugin = vim.pack.get({ 'nvim-treesitter-context' })
      if #plugin > 0 and plugin[1].active then require('treesitter-context').enable() end
    end
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('ModeChanged', {
  callback = function()
    if u.in_macro_executing() then return end
    if vim.tbl_contains({ 'i', 'ic', 'ix', 'R', 'Rc', 'Rx', 'Rv', 'Rvc', 'Rvx' }, vim.api.nvim_get_mode().mode) then
      -- We must schedule here
      vim.schedule(function() vim.cmd('nohlsearch') end)
    end
  end,
})

local limit = 1024 * 1024 -- 1 MB
local timeout = 300 -- Unit: ms
vim.schedule_wrap(vim.api.nvim_create_autocmd)('TextYankPost', {
  callback = function()
    assert(vim.v.event.regcontents)
    local size = 0
    local should_hl = nil
    ---@diagnostic disable-next-line: param-type-mismatch
    for _, line in ipairs(vim.v.event.regcontents) do
      size = size + #line
      if size > 0 then
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
  callback = function()
    if u.enabled('treesitter_highlight_auto_start') and u.treesitter_available('highlights') then
      vim.treesitter.start()
    end
    if u.enabled('treesitter_foldexpr_auto_set') and u.treesitter_available('folds') then
      vim.wo[0][0].foldmethod = 'expr'
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('LspAttach', {
  callback = function(ev)
    -- WARN:
    -- With those keys below,
    -- we can not use something like "grn" to enter visual replace mode and change a character to "n"
    -- gr not work
    local lsp_m = {
      -- By default, "tagfunc" is set whne "LspAttach",
      -- "<C-]>", "<C-W>]", and "<C-W>}" will work, you can use them to go to definition
      { 'n', 'K', vim.lsp.buf.hover, { desc = 'Hover' } },
      { 'n', 'grn', vim.lsp.buf.rename, { desc = 'Rename Symbol' } },
      { 'n', 'gra', vim.lsp.buf.code_action, { desc = 'Code Action' } },
      { 'n', 'grx', vim.lsp.codelens.run, { desc = 'Codelens' } },
      { 'n', 'grr', '<cmd>Telescope lsp_references<cr>', { desc = 'References' } },
      { 'n', 'grI', '<cmd>Telescope lsp_implementations<cr>', { desc = 'Go to Implementation' } },
      { 'n', 'gri', '<cmd>Telescope lsp_incoming_calls<cr>', { desc = 'Incoming Call' } },
      { 'n', 'gro', '<cmd>Telescope lsp_outgoing_calls<cr>', { desc = 'Outgoint Call' } },
      { 'n', 'grt', '<cmd>Telescope lsp_type_definitions<cr>', { desc = 'Go to Type Definition' } },
      { 'n', 'gO', '<cmd>Telescope lsp_document_symbols<cr>', { desc = 'Document Symbol' } },
    }
    for _, m in ipairs(lsp_m) do
      m[4].buffer = ev.buf
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.keymap.set(unpack(m))
    end
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)({ 'FocusLost', 'BufLeave' }, {
  callback = function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if u.buffer.normal(bufnr) and vim.bo[bufnr].modified then
        vim.api.nvim_buf_call(bufnr, function() vim.cmd('update') end)
      end
    end
  end,
})

local unnamed_reg_content
local unnamed_reg_type
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    unnamed_reg_content = vim.fn.getreg('"')
    unnamed_reg_type = vim.fn.getregtype('"')
  end,
  once = true,
})
vim.schedule_wrap(vim.api.nvim_create_autocmd)('TextYankPost', {
  callback = function()
    if vim.v.event.regname ~= '' and vim.v.event.regname ~= '"' then
      vim.fn.setreg('"', unnamed_reg_content, unnamed_reg_type)
    else
      unnamed_reg_content = vim.fn.getreg('"')
      unnamed_reg_type = vim.fn.getregtype('"')
    end
  end,
})

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name ~= 'nvim-treesitter' or kind == 'update' then
      if not ev.data.active then vim.cmd.packadd(name) end
      u.build_plugin(name)
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    if not u.buffer.normal(ev.buf) then return end
    local plugin = vim.pack.get({ 'guess-indent.nvim' })
    if #plugin > 0 and plugin[1].active then require('guess-indent').set_from_buffer(ev.buf, true, true) end
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('BufWritePre', {
  callback = function(ev)
    if not u.enabled('conform_on_save') then return end
    local buffer = ev.buf
    local plugin = vim.pack.get({ 'conform.nvim' })
    if #plugin > 0 and plugin[1].active then
      require('conform').format({ bufnr = buffer }, function(err)
        if err then return end
        plugin = vim.pack.get({ 'guess-indent.nvim' })
        if #plugin > 0 and plugin[1].active then require('guess-indent').set_from_buffer(ev.buf, true, true) end
      end)
    end
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('LspAttach', {
  callback = function()
    local plugin = vim.pack.get({ 'conform.nvim' })
    if #plugin > 0 and plugin[1].active then vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('User', {
  pattern = 'TelescopePreviewerLoaded',
  callback = function() vim.wo.wrap = true end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)({ 'BufEnter', 'QuitPre' }, {
  nested = false,
  callback = function(ev)
    local plugin = vim.pack.get({ 'nvim-tree.lua' })
    if #plugin == 0 or not plugin[1].active then return end
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
