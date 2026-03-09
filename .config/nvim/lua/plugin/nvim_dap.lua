local function get_exe()
  if type(vim.g.dap_exe) == 'string' and vim.g.dap_exe ~= '' then return vim.g.dap_exe end
  local default = vim.fn.getcwd() .. '/'
  vim.g.dap_exe = vim.fn.input('Path to Executable', default, 'file')
  return vim.g.dap_exe
end
local function get_pid()
  if type(vim.g.dap_pid) == 'number' then return vim.g.dap_pid end
  local dap = require('dap')
  if vim.g.dap_pname and vim.g.dap_pname ~= '' then return dap.utils.pick_process({ filter = vim.g.dap_pname }) end
  local default = vim.fn.getcwd() .. '/'
  local id_or_name = vim.fn.input('Process ID or Executable Name (Filter)', default, 'file')
  local pid = tonumber(id_or_name)
  if pid then
    vim.g.dap_pid = pid
    return vim.g.dap_pid
  else
    vim.g.dap_pname = id_or_name
  end
  return dap.utils.pick_process({ filter = vim.g.dap_pname })
end
local function get_server()
  if type(vim.g.dap_server) == 'string' and vim.g.dap_server ~= '' then return vim.g.dap_server end
  local default = 'localhost:1234'
  vim.g.dap_server = vim.fn.input('Server IP and Host', default)
  return vim.g.dap_server
end
local c_cpp_configuration = {
  {
    name = 'Launch (codelldb)',
    type = 'codelldb',
    request = 'launch',
    program = get_exe,
    cwd = '${workspaceFolder}',
  },
  {
    name = 'Attach (codelldb)',
    type = 'codelldb',
    request = 'attach',
    pid = get_pid,
    program = get_exe,
    cwd = '${workspaceFolder}',
  },
  {
    name = 'Launch (gdb)',
    type = 'gdb',
    request = 'launch',
    program = get_exe,
    cwd = '${workspaceFolder}',
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = 'Attach (gdb)',
    type = 'gdb',
    request = 'attach',
    pid = get_pid,
    program = get_exe,
    cwd = '${workspaceFolder}',
  },
  {
    name = 'Remote (gdb)',
    type = 'gdb',
    request = 'attach',
    target = get_server,
    program = get_exe,
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
      c = c_cpp_configuration,
      cpp = c_cpp_configuration,
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
