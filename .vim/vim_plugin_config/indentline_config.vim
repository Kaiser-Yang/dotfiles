
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.
" prevent indent line close []() of markdown files
autocmd FileType markdown let g:indentLine_setConceal = 0
autocmd FileType markdown :IndentLinesDisable
autocmd FileType vimwiki let g:indentLine_setConceal = 0
autocmd FileType vimwiki :IndentLinesDisable
autocmd FileType none let g:indentLine_setConceal = 0
autocmd FileType none :IndentLinesDisable
" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue

