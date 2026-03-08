local c_cpp_rust_configuration = {
  {
    name = 'Launch File',
    type = 'codelldb',
    request = 'launch',
    program = function()
      if vim.g.dap_exe and vim.g.dap_exe ~= '' then return vim.g.dap_exe end
      local default = vim.fn.getcwd() .. '/'
      vim.g.dap_exe = vim.fn.input('Path to Executable: ', default, 'file')
      return vim.g.dap_exe
    end,
    cwd = '${workspaceFolder}',
  },
}
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'leoluz/nvim-dap-go',
    { 'mfussenegger/nvim-dap-python', config = function() require('dap-python').setup('python') end },
  },
  config = function()
    local dap = require('dap')
    dap.adapters = { codelldb = { type = 'executable', command = 'codelldb' } }
    dap.configurations = {
      c = c_cpp_rust_configuration,
      cpp = c_cpp_rust_configuration,
      rust = c_cpp_rust_configuration,
    }
  end,
}
