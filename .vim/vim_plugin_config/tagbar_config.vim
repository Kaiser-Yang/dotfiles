
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.

" save files before open tagbar
fun! BeforeTagbarSaveCheck()
    if &buftype == ''
        exec "w"
    endif
endf
nnoremap <C-w> :call BeforeTagbarSaveCheck()<CR>:TagbarToggle<CR>
inoremap <C-w> <Esc>:call BeforeTagbarSaveCheck()<CR>:TagbarToggle<CR>
" once open, cursor is in tagbar window
let g:tagbar_autofocus = 1
" open at left
let g:tagbar_position = 'topleft vertical'
" when tagbar is the last window, close it automatically
let g:tagbar_autoclose_netrw = 1
" show line numbers of functions
let g:tagbar_show_linenumbers = 1
" Add support for markdown files in tagbar.
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '~/.vim/autoload/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes --sro=»',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '»',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }
" Add support for vimwiki files in tagbar.
let g:tagbar_type_vimwiki = {
    \ 'ctagstype': 'vimwiki',
    \ 'ctagsbin' : '~/.vim/autoload/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes --sro=»',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '»',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }
" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue

