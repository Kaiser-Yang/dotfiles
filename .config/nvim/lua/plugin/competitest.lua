vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
  callback = function()
    if not vim.fn.getcwd():match('OJProblems') then return end
    vim.api.nvim_exec_autocmds('User', { pattern = 'OJPDetected' })
  end,
})
return {
  'xeluxee/competitest.nvim',
  dependencies = 'MunifTanjim/nui.nvim',
  event = { { event = 'User', pattern = 'OJPDetected' } },
  cmd = 'CompetiTest',
  opts = {
    testcases_input_file_format = '$(FNOEXT)_$(TCNUM).in',
    testcases_output_file_format = '$(FNOEXT)_$(TCNUM).out',
    compile_command = {
      cpp = { exec = 'g++', args = { '-g', '-Wall', '$(FNAME)', '-o', '$(FNOEXT).out', '-std=c++23' } },
    },
    run_command = { cpp = { exec = './$(FNOEXT).out' } },
    picker_ui = {
      mappings = {
        focus_next = 'j',
        focus_prev = 'k',
        close = { '<esc>', 'q' },
        submit = '<cr>',
      },
    },
    editor_ui = {
      normal_mode_mappings = {
        switch_window = {},
        save_and_close = { '<c-s>', '<m-s>' },
        cancel = { '<esc>', 'q' },
      },
      insert_mode_mappings = {
        switch_window = {},
        save_and_close = { '<c-s>', '<m-s>' },
        cancel = { '<c-c>' },
      },
    },
    runner_ui = {
      interface = 'split',
      mappings = {
        run_again = 'r',
        run_all_again = 'R',
        kill = '<c-c>',
        kill_all = {},
        view_input = 'i',
        view_output = 'a',
        view_stdout = 'o',
        view_stderr = 'e',
        toggle_diff = 'd',
        close = { 'q', '<esc>' },
      },
    },
  },
}
