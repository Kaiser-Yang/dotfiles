vim.g.NERDCreateDefaultMappings = 1
vim.g.NERDSpaceDelims = 1
vim.g.NERDCompactSexyComs = 1
vim.g.NERDDefaultAlign = 'both'
vim.g.NERDCommentEmptyLines = 1
vim.g.NERDTrimTrailingWhitespace = 1
vim.g.NERDToggleCheckAllLines = 1

-- vim.cmd [[
-- nnoremap <silent> <leader>c} V}:call nerdcommenter#Comment('x', 'toggle')<CR>
-- nnoremap <silent> <leader>c{ V{:call nerdcommenter#Comment('x', 'toggle')<CR>
-- ]]

-- Set a language to use its alternate delimiters by default
-- vim.g.NERDAltDelims_java = 1

-- Add your own custom formats or override the defaults
-- let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
