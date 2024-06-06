
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.

" Don't use fly mode anymore
" use ^B to add brackets when mismatch
" let g:AutoPairsFlyMode = 1
" let g:AutoPairsShortcutBackInsert = '<C-b>'

" don't use this ^A is the prefix for tmux
" use surrounding's key like: ysw)
" use ^A to wrap
" let g:AutoPairsShortcutFastWrap = '<C-a>'

" double quotation is vim's comment sign, so remove it from auto pairs of vim files
autocmd Filetype vim let b:AutoPairs = {'(':')', '[':']', '{':'}', "'":"'", "`":"`", '```':'```', '"""':'"""', "'''":"'''"}
" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue

