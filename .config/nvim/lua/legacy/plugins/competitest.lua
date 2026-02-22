vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
  callback = function()
    if vim.fn.getcwd():match('OJProblems') then vim.api.nvim_exec_autocmds('User', { pattern = 'OJPDetected' }) end
  end,
})
return {
  'xeluxee/competitest.nvim',
  dependencies = 'MunifTanjim/nui.nvim',
  event = { { event = 'User', pattern = 'OJPDetected' } },
  opts = {
    testcases_input_file_format = '$(FNOEXT)_$(TCNUM).in',
    testcases_output_file_format = '$(FNOEXT)_$(TCNUM).out',
    compile_command = {
      cpp = { exec = 'g++', args = { '-Wall', '$(FNAME)', '-o', '$(FNOEXT).out', '-std=c++23' } },
    },
    run_command = {
      cpp = { exec = './$(FNOEXT).out' },
    },
  },
}
