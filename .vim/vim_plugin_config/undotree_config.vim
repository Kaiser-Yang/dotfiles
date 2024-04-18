
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.
" use ^Q to open undotree
nnoremap <C-q> <Nop>
nnoremap <C-q> :UndotreeToggle<CR>:UndotreeFocus<CR>
inoremap <C-q> <Nop>
inoremap <C-q> <ESC>:UndotreeToggle<CR>:UndotreeFocus<CR>
" use :UndotreePersistUndo to save the history into a file
if has("persistent_undo")
   let target_path = expand('~/.undodir')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif
" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue

