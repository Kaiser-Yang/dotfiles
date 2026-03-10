local function get_exe()
  return coroutine.create(function(dap_run_co)
    vim.ui.input({
      prompt = 'Path to Executable',
      default = vim.fn.getcwd() .. '/',
    }, function(input) coroutine.resume(dap_run_co, input) end)
  end)
end

local function get_pid()
  return coroutine.create(function(dap_run_co)
    vim.ui.input({
      prompt = 'Process ID',
    }, function(input)
      local pid = tonumber(input)
      coroutine.resume(dap_run_co, pid)
    end)
  end)
end

local function get_arg()
  return coroutine.create(function(dap_run_co)
    vim.ui.input({ prompt = 'Arg' }, function(input)
      local args = vim.split(input or '', ' ')
      coroutine.resume(dap_run_co, args)
    end)
  end)
end

local c_cpp_rust_configuration = {
  {
    name = 'Launch (codelldb)',
    type = 'codelldb',
    request = 'launch',
    program = get_exe,
    cwd = '${workspaceFolder}',
  },
  {
    name = 'Launch with Arg (codelldb)',
    type = 'codelldb',
    request = 'launch',
    program = get_exe,
    args = get_arg,
    cwd = '${workspaceFolder}',
  },
  {
    name = 'Attach (codelldb)',
    type = 'codelldb',
    request = 'attach',
    pid = get_pid,
    cwd = '${workspaceFolder}',
  },
  -- NOTE:
  -- For gdb, we can not input or output to terminal
  -- https://sourceware.org/gdb/current/onlinedocs/gdb.html/Debugger-Adapter-Protocol.html#Debugger-Adapter-Protocol
  {
    name = 'Launch (gdb)',
    type = 'gdb',
    request = 'launch',
    program = get_exe,
    cwd = '${workspaceFolder}',
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = 'Launch with Arg (gdb)',
    type = 'gdb',
    request = 'launch',
    program = get_exe,
    args = get_arg,
    cwd = '${workspaceFolder}',
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = 'Attach (gdb)',
    type = 'gdb',
    request = 'attach',
    pid = get_pid,
    cwd = '${workspaceFolder}',
  },
}
return {
  'mfussenegger/nvim-dap',
  config = function()
    local dap = require('dap')
    dap.adapters = {
      codelldb = { type = 'executable', command = 'codelldb' },
      gdb = {
        type = 'executable',
        command = 'gdb',
        args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
      },
      debugpy = function(cb, config)
        if config.request == 'attach' then
          local port = (config.connect or config).port
          local host = (config.connect or config).host or '127.0.0.1'
          local adapter = {
            type = 'server',
            port = port,
            host = host,
            options = { source_filetype = 'python' },
          }
          cb(adapter)
        else
          local adapter = {
            type = 'executable',
            command = 'python',
            args = { '-m', 'debugpy.adapter' },
            options = { source_filetype = 'python' },
          }
          cb(adapter)
        end
      end,
      delve = function(cb, config)
        if config.mode == 'remote' and config.request == 'attach' then
          cb({
            type = 'server',
            host = config.host or '127.0.0.1',
            port = config.port or '38697',
          })
        else
          cb({
            type = 'server',
            port = '${port}',
            executable = {
              command = 'dlv',
              args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
            },
          })
        end
      end,
    }
    dap.configurations = {
      c = c_cpp_rust_configuration,
      cpp = c_cpp_rust_configuration,
      rust = c_cpp_rust_configuration,
      python = {
        {
          name = 'Launch',
          type = 'debugpy',
          request = 'launch',
          program = get_exe,
          console = 'integratedTerminal',
          pythonPath = 'python',
        },
        {
          name = 'Attach to Server',
          type = 'debugpy',
          request = 'attach',
          connect = function()
            get_server()
            local host, port = unpack(vim.split(vim.g.dap_server, ':'))
            return { host = host, port = port }
          end,
        },
      },
      go = {
        {
          name = 'Launch',
          type = 'delve',
          request = 'launch',
          program = '${file}',
        },
        {
          name = 'Launch (Package)',
          type = 'delve',
          request = 'launch',
          program = '${fileDirname}',
        },
        {
          name = 'Launch (Test)',
          type = 'delve',
          request = 'launch',
          mode = 'test',
          program = '${file}',
        },
        {
          name = 'Launch (Test go.mod)',
          type = 'delve',
          request = 'launch',
          mode = 'test',
          program = './${relativeFileDirname}',
        },
        {
          name = 'Attach',
          type = 'delve',
          mode = 'local',
          request = 'attach',
          processId = get_pid,
        },
      },
    }
  end,
}
