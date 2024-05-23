if (has("termguicolors"))
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
let g:one_allow_italics = 1
colorscheme one
set background=dark
" transparent backgrounds
highlight Normal ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE
highlight FoldColumn ctermbg=NONE guibg=NONE

" Spell check highlights
highlight SpellBad guisp=NONE guifg=#e06c75 ctermfg=168 cterm=bold,underline gui=bold,underline
highlight SpellCap guisp=NONE guifg=#d19a66 ctermfg=173 cterm=bold gui=bold
highlight SpellRare guisp=NONE guifg=#c678dd ctermfg=176 cterm=bold,underline gui=bold,underline
highlight SpellLocal guisp=NONE guifg=Cyan ctermfg=Cyan cterm=bold,underline gui=bold,underline
