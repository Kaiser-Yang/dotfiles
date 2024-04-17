
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.
nnoremap <C-o> <Nop>
nnoremap <C-o> :TagbarToggle<CR>
inoremap <C-o> <Nop>
inoremap <C-o> <ESC>:TagbarToggle<CR>
" once open, cursor is in tagbar window
let g:tagbar_autofocus = 1
" open at left
let g:tagbar_position = 'topleft vertical'
" when tagbar is the last window, close it automatically
let g:tagbar_autoclose_netrw = 1
" show line numbers of functions
let g:tagbar_show_linenumbers = 1
" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue

