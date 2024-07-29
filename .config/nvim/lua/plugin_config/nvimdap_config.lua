require("nvim-dap-virtual-text").setup()
local dap, dapui = require("dap"), require("dapui")
dapui.setup()
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = vim.fn.expand("~") .. '/codelldb/extension/adapter/codelldb',
    args = {"--port", "${port}"},
    -- On windows you may have to uncomment this:
    -- detached = false,
  }
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      -- local ok, xmakepath = pcall(function()
      --   return require("xmake.project_config").info.target.exec_path
      -- end)
      -- if ok then
      --   return xmakepath
      -- end
        -- TODO: cmake path?
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
  -- {
  --   name = "Attach to process",
  --   type = "codelldb",
  --   request = "launch",
  --   program = function()
  --     return vim.fn.input('Process PID: ', vim.fn.getcwd() .. '/', 'file')
  --   end,
  --   cwd = '${workspaceFolder}',
  --   stopOnEntry = false,
  -- },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    local port = (config.connect or config).port
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command = vim.fn.expand("~") .. '/.virtualenvs/debugpy/bin/python',
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    })
  end
end
dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = "Launch file",
        console = "integratedTerminal",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        pythonPath = function()
            local python_path = vim.fn.system('which python')
            python_path = python_path:gsub("\n", "")
            return python_path
        end,
    },
}

dap.listeners.before.attach.dapui_config = function()
    if require('nvim-tree.api').tree.is_visible() then
        Nvim_tree_visible = true
        require('nvim-tree.api').tree.close()
    end
    DapUIVisible = true
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    if require('nvim-tree.api').tree.is_visible() then
        Nvim_tree_visible = true
        require('nvim-tree.api').tree.close()
    end
    DapUIVisible = true
    dapui.open()
end

vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='⭕', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='🚫', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='📔', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='👉', texthl='', linehl='', numhl=''})
