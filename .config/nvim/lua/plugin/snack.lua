local keys = {
  ['<up>'] = false,
  ['<down>'] = false,
  ['<m-p>'] = { 'history_back', mode = { 'i', 'n' } },
  ['<m-n>'] = { 'history_forward', mode = { 'i', 'n' } },
  ['<m-P>'] = { 'toggle_preview', mode = { 'i', 'n' } },
}
return {
  'Kaiser-Yang/snacks.nvim',
  opts = { picker = { win = { input = { keys = keys }, list = { keys = keys } } } },
}
