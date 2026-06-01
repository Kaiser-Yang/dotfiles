local u = require('utils')
u.gh('nvim-tree/nvim-web-devicons')
u.gh('MagicDuck/grug-far.nvim')
require('grug-far').setup({
  folding = { foldlevel = vim.o.foldlevel, foldcolumn = vim.o.foldcolumn, include_file_path = true },
  breakindentopt = vim.o.breakindentopt,
  disableBufferLineNumbers = false,
  enabledEngines = { 'ripgrep' },
  engines = { ripgrep = { extraArgs = u.in_config_dir() and '--hidden' or '' } },
  -- * 'default': treat replacement as a string to pass to the current engine
  -- * 'lua': treat replacement as lua function body where search match is identified by `match` and
  --          meta variables (with astgrep for example) are available in `vars` table (e.g. `vars.A` captures `$A`)
  enabledReplacementInterpreters = { 'default', 'lua' },
  keymaps = {
    prevInput = false,
    nextInput = false,
    qflist = { n = '<c-q>', i = '<c-q>' },
    close = { n = 'q' },
    refresh = { n = '<f5>', i = '<f5>' },
    previewLocation = { n = 'K' },
    help = false,
    replace = { n = '<leader>r' },
    applyNext = false,
    applyPrev = false,
    syncLocations = { n = '<leader>ss' },
    syncLine = { n = '<leader>sl' },
    syncFile = { n = '<leader>sf' },
    syncNext = false,
    syncPrev = false,
    historyOpen = { n = 'gh' },
    historyAdd = false,
    pickHistoryEntry = { n = '<cr>' },
    openLocation = { n = 'go' },
    openNextLocation = false,
    openPrevLocation = false,
    gotoLocation = { n = '<cr>' },
    abort = { n = '<c-c>' },
    toggleShowCommand = { n = '<m-s>', i = '<m-s>' },
    swapReplacementInterpreter = { n = '<m-i>', i = '<m-i>' },
    swapEngine = false,
  },
  openTargetWindow = { exclude = { function(win) return vim.wo[win][0].winfixbuf end } },
})
