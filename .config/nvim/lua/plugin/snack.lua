return {
  'Kaiser-Yang/snacks.nvim',
  keys = {
    {
      '<leader>sh',
      function() Snacks.picker.help({ layout = { hidden = { 'preview' } } }) end,
      desc = 'Help Pages',
    },
  },
}
