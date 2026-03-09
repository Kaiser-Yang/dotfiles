return {
  'igorlfs/nvim-dap-view',
  opts = {
    winbar = {
      base_sections = {
        breakpoints = { label = 'Breakpoint', keymap = 'B' },
        scopes = { label = 'Scope', keymap = 'S' },
        exceptions = { label = 'Exception', keymap = 'E' },
        watches = { label = 'Watch', keymap = 'W' },
        threads = { label = 'Thread', keymap = 'T' },
        repl = { label = 'REPL', keymap = 'R' },
        sessions = { label = 'Session', keymap = 'K' },
      },
    },
  },
}
