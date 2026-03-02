vim.g.rime_enabled = false

local function rime_on_attach(client, _)
  -- Toggle rime
  vim.keymap.set({ 'n', 'i' }, '<c-space>', function()
    vim.g.rime_enabled = not vim.g.rime_enabled
    client.request('workspace/executeCommand', { command = 'rime-ls.toggle-rime' }, function() end)
  end)
end

local shared_data_dir
if vim.fn.has('mac') == 1 then
  shared_data_dir = '/Library/Input Methods/Squirrel.app/Contents/SharedSupport'
elseif vim.fn.has('linux') == 1 then
  shared_data_dir = '/usr/share/rime-data'
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
}
