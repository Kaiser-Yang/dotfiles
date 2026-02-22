return {
  on_init = function(client)
    if not client.workspace_folders then return end
    local util = require('lightboat.util')
    if not util.in_config_dir() then return end
    local lazy_path = util.lazy_path()
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = { 'lua/?.lua', 'lua/?/init.lua' },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          lazy_path .. '/LightBoat',
          '${3rd}/luv/library',
        },
      },
    })
  end,
  settings = { Lua = {} },
}
