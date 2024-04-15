
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.
" ^P to open CtrlP pluggin
let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
\ 'dir':  '\v([\/]\.(git|hg|svn)$|build)',
\ 'file': '\v\.(exe|so|dll)$',
\ }
" let dot files be included in ctrlp
let g:ctrlp_show_hidden = 1
" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue

