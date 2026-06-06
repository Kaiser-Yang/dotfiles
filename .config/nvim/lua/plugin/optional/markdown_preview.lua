local u = require('utils')
u.gh('selimacerbas/live-server.nvim')
u.gh('selimacerbas/markdown-preview.nvim')
require('markdown_preview').setup({
  -- "takeover" (one tab) or "multi" (tab per instance)
  instance_mode = 'takeover',
})
