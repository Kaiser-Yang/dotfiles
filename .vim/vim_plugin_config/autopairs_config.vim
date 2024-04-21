
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.
" use ^A to add brackets when mismatch
let g:AutoPairsShortcutBackInsert = '<C-a>'
let g:AutoPairsFlyMode = 1
" double quotation is vim's comment sign, so remove it from auto pairs of vim files
autocmd Filetype vim let b:AutoPairs = {'(':')', '[':']', '{':'}', "'":"'", "`":"`", '```':'```', '"""':'"""', "'''":"'''"}
" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue

