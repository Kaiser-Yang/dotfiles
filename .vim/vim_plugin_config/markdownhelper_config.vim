
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.
" this expiration comes from https://github.com/theniceboy/.vim/blob/master/snippits.vim

" if you press quickly, it will trigger, otherwise, it just add two characters
" this is resonable, in english, we usually add space after comma rather than letters.

" find next placeholder and remove it.
autocmd Filetype markdown inoremap ,f <Esc>/<++><CR>:nohlsearch<CR>c4l
autocmd Filetype gitcommit inoremap ,f <Esc>/<++><CR>:nohlsearch<CR>c4l

" bold
autocmd Filetype markdown inoremap ,b ****<++><Esc>F*hi
autocmd Filetype gitcommit inoremap ,b ****<++><Esc>F*hi

" italic
autocmd Filetype markdown inoremap ,i **<++><Esc>F*i
autocmd Filetype gitcommit inoremap ,i **<++><Esc>F*i

" for code blocks
autocmd Filetype markdown inoremap ,c <CR><CR>```<CR>```<CR><CR><++><Esc>3kA
autocmd Filetype gitcommit inoremap ,c <CR><CR>```<CR>```<CR><CR><++><Esc>3kA

" for pictures, mostly, we don't add pictures' descriptions
autocmd Filetype markdown inoremap ,p <CR><CR>![]()<CR><CR><++><Esc>2k0f(a
autocmd Filetype gitcommit inoremap ,p <CR><CR>![]()<CR><CR><++><Esc>2k0f(a

" for for links <a> are html links tag, so we use ,a
autocmd Filetype markdown inoremap ,a [](<++>)<++><Esc>F[a
autocmd Filetype gitcommit inoremap ,a [](<++>)<++><Esc>F[a

" for headers
autocmd Filetype markdown inoremap ,1 #<Space>
autocmd Filetype gitcommit inoremap ,1 #<Space>
autocmd Filetype markdown inoremap ,2 ##<Space>
autocmd Filetype gitcommit inoremap ,2 ##<Space>
autocmd Filetype markdown inoremap ,3 ###<Space>
autocmd Filetype gitcommit inoremap ,3 ###<Space>
autocmd Filetype markdown inoremap ,4 ####<Space>
autocmd Filetype gitcommit inoremap ,4 ####<Space>

" delete lines
autocmd Filetype markdown inoremap ,d ~~~~<++><Esc>F~hi
autocmd Filetype gitcommit inoremap ,d ~~~~<++><Esc>F~hi

" tilde
autocmd Filetype markdown inoremap ,t ``<++><Esc>F`i
autocmd Filetype gitcommit inoremap ,t ``<++><Esc>F`i

" math formulas
autocmd Filetype markdown inoremap ,M <CR><CR>$$<CR><CR>$$<CR><CR><++><Esc>3kA
autocmd Filetype gitcommit inoremap ,M <CR><CR>$$<CR><CR>$$<CR><CR><++><Esc>3kA

" math formulas in line
autocmd Filetype markdown inoremap ,m $$<++><Esc>F$i
autocmd Filetype gitcommit inoremap ,m $$<++><Esc>F$i

" newline but not new paragraph
autocmd FileType markdown inoremap ,n <br><CR>
autocmd FileType gitcommit inoremap ,n <br><CR>

" use mouse in markdown file,
" this is useful when you are write Chinese
" which is inconvenient to navigate with f/F or t/T.
autocmd FileType markdown set mouse+=a
autocmd FileType gitcommit set mouse+=a
" not used
" autocmd Filetype markdown inoremap ,n ---<CR><CR>
" autocmd Filetype gitcommit inoremap ,n ---<CR><CR>
" autocmd Filetype markdown inoremap ,l --------<CR>
" autocmd Filetype gitcommit inoremap ,l --------<CR>
" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue

