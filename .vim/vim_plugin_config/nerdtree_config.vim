
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.
" vim nerdtree config
" open nerdtree use ^E
" if you want to open a nerdtree which is same with the previous opened one,
" just use <C-S-e>
nnoremap <C-e> <Nop>
nnoremap <C-e> :NERDTreeToggle<CR>
nnoremap <C-S-e> <Nop>
nnoremap <C-S-e> :NERDTreeMirror<CR>:NERDTreeFocus<CR>

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

" show dot files
let g:NERDTreeShowHidden = 1

" set nerdtree sort by numerical
let g:NERDTreeNaturalSort = 1

" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue

