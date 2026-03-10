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
    }, function(input) coroutine.resume(dap_run_co, tonumber(input)) end)
  end)
end

local function get_arg()
  return coroutine.create(function(dap_run_co)
    vim.ui.input({ prompt = 'Arg' }, function(input) coroutine.resume(dap_run_co, vim.split(input or '', ' ')) end)
  end)
end

local function get_connect()
  return coroutine.create(function(dap_run_co)
    vim.ui.input({
      prompt = 'Attach to Server',
      default = 'localhost:1234',
    }, function(input)
      local res = nil
      if input then
        local parts = vim.split(input, ':')
        if #parts == 2 then
          local host = parts[1]
          local port = tonumber(parts[2])
          if port then res = { host = host, port = port } end
        end
      end
      coroutine.resume(dap_run_co, res)
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
      delve = function(callback, client_config)
        local delve_config = {
          type = 'server',
          port = '${port}',
          executable = { command = 'dlv', args = { 'dap', '-l', '127.0.0.1:${port}' } },
          options = { initialize_timeout_sec = 20 },
        }

        if client_config.port == nil then
          callback(delve_config)
          return
        end

        local host = client_config.host
        if host == nil then host = '127.0.0.1' end

        local listener_addr = host .. ':' .. client_config.port
        delve_config.port = client_config.port
        delve_config.executable.args = { 'dap', '-l', listener_addr }
        callback(delve_config)
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
          name = 'Launch with Arg',
          type = 'debugpy',
          request = 'launch',
          program = get_exe,
          args = get_arg,
          console = 'integratedTerminal',
          pythonPath = 'python',
        },
        {
          name = 'Attach to Server',
          type = 'debugpy',
          request = 'attach',
          connect = get_connect,
        },
      },
      go = {
        {
          name = 'Launch',
          type = 'delve',
          request = 'launch',
          program = '${file}',
          outputMode = 'remote',
        },
        {
          name = 'Launch with Arg',
          type = 'delve',
          request = 'launch',
          program = '${file}',
          args = get_arg,
          outputMode = 'remote',
        },
        {
          name = 'Launch (Package)',
          type = 'delve',
          request = 'launch',
          program = '${fileDirname}',
          outputMode = 'remote',
        },
        {
          name = 'Launch (Test)',
          type = 'delve',
          request = 'launch',
          mode = 'test',
          program = '${file}',
          outputMode = 'remote',
        },
        {
          name = 'Launch (Test go.mod)',
          type = 'delve',
          request = 'launch',
          mode = 'test',
          program = './${relativeFileDirname}',
          outputMode = 'remote',
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
