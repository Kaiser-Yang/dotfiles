vim.g.rime_enabled = false
local function toggle_rime(client)
  client.request('workspace/executeCommand', { command = 'rime-ls.toggle-rime' }, function(_, result, ctx, _)
    if ctx.client_id == client.id then vim.g.rime_enabled = result end
  end)
end

local function rime_on_attach(client, _)
  -- Toggle rime
  vim.keymap.set({ 'n', 'i' }, '<m-space>', function()
    -- We must check the status before the toggle
    vim.g.rime_enabled = not vim.g.rime_enabled
    toggle_rime(client)
  end)
end

local shared_data_dir
if vim.fn.has('mac') == 1 then
  shared_data_dir = '/Library/Input Methods/Squirrel.app/Contents/SharedSupport'
elseif vim.fn.has('linux') == 1 then
  shared_data_dir = '/usr/share/rime-data'
elseif vim.fn.has('win32') == 1 then
  vim.notify('Rime LS is not supported on Windows. Please use rime-ls on WSL.', vim.log.levels.WARN)
else
  vim.notify('Rime LS is not supported on this platform.', vim.log.levels.WARN)
end
return {
  name = 'rime_ls',
  cmd = { 'rime_ls' },
  init_options = {
    enabled = vim.g.rime_enabled,
    shared_data_dir = shared_data_dir,
    user_data_dir = vim.fn.expand('~/.local/share/rime-ls'),
    log_dir = vim.fn.expand('~/.local/share/rime-ls'),
    always_incomplete = true,
    long_filter_text = true,
  },
  on_attach = rime_on_attach,
  handlers = {
    ['$/progress'] = function(_, _, _) end,
  },
}
