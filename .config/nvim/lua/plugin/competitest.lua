vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
  callback = function()
    if not vim.fn.getcwd():match('OJProblems') then return end
    vim.api.nvim_exec_autocmds('User', { pattern = 'OJPDetected' })
    vim.keymap.set('n', '<leader>r', function()
      if not vim.fn.expand('%:p'):match('OJProblems') or vim.bo.filetype ~= 'cpp' then return end
      local file_dir = vim.fn.expand('%:p:h')
      local file_name = vim.fn.expand('%:t:r')
      if vim.fn.filereadable(file_dir .. '/' .. file_name .. '_0.in') == 0 then
        vim.cmd('CompetiTest receive testcases')
        return
      end
      vim.cmd('CompetiTest run')
    end, { desc = 'CompetiTest' })
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
      cpp = { exec = 'g++', args = { '-g', '-Wall', '$(FNAME)', '-o', '$(FNOEXT).out', '-std=c++23' } },
    },
    run_command = { cpp = { exec = './$(FNOEXT).out' } },
  },
}
