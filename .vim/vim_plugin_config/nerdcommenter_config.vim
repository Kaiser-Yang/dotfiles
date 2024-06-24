
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.
" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush start instead of following code indentation
let g:NERDDefaultAlign = 'start'

" Set a language to use its alternate delimiters by default
" let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
" let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1

" This enables you can comment for closed () and {}
nnoremap <silent> <leader>c% V%:call nerdcommenter#Comment('x', 'toggle')<CR>
" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue

