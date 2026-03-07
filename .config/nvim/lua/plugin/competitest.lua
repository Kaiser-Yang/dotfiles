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
    template_file = { cpp = vim.fn.stdpath('config') .. '/cp/template.cpp' },
    evaluate_template_modifiers = true,
    received_problems_path = function(task, file_ext)
      local sub_dir
      local filename = 'unknown'
      if task.url:find('codeforces') then
        sub_dir = 'CodeForces'
        ---@diagnostic disable-next-line: unbalanced-assignments
        local number, letter = task.url:match('/problemset/problem/(%d+)/([A-Z]+)')
          or task.url:match('/contest/(%d+)/problem/([A-Z]+)')
        if number and letter then filename = number .. letter end
      elseif task.url:find('luogu') then
        sub_dir = 'Luogu'
        local id = task.url:match('/problem/([A-Za-z0-9]+)')
        if id then filename = id end
      elseif task.url:find('leetcode') then
        sub_dir = 'LeetCode'
      elseif task.url:find('uva') then
        sub_dir = 'UVa'
        local id = task.url:match('UVA%-?(%d+)')
        if id then filename = id end
      else
        sub_dir = 'Other'
      end

      return vim.fn.getcwd() .. '/' .. sub_dir .. '/' .. filename .. '.' .. file_ext
    end,
  },
}
