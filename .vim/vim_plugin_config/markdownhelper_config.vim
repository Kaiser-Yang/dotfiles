
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.
" this expiration comes from https://github.com/theniceboy/.vim/blob/master/snippits.vim

" if you press quickly, it will trigger, otherwise, it just add two characters
" this is resonable, in english, we usually add space after comma rather than letters.

" find next placeholder and remove it.
autocmd Filetype markdown inoremap<buffer> ,f <Esc>/<++><CR>:nohlsearch<CR>c4l
autocmd Filetype gitcommit inoremap<buffer> ,f <Esc>/<++><CR>:nohlsearch<CR>c4l

" bold
autocmd Filetype markdown inoremap<buffer> ,b ****<++><Esc>F*hi
autocmd Filetype gitcommit inoremap<buffer> ,b ****<++><Esc>F*hi

" italic
autocmd Filetype markdown inoremap<buffer> ,i **<++><Esc>F*i
autocmd Filetype gitcommit inoremap<buffer> ,i **<++><Esc>F*i

" for code blocks
autocmd Filetype markdown inoremap<buffer> ,c <CR><CR>```<CR>```<CR><CR><++><Esc>3kA
autocmd Filetype gitcommit inoremap<buffer> ,c <CR><CR>```<CR>```<CR><CR><++><Esc>3kA

" for pictures, mostly, we don't add pictures' descriptions
autocmd Filetype markdown inoremap<buffer> ,p <CR><CR>![]()<CR><CR><++><Esc>2k0f(a
autocmd Filetype gitcommit inoremap<buffer> ,p <CR><CR>![]()<CR><CR><++><Esc>2k0f(a

" for for links <a> are html links tag, so we use ,a
autocmd Filetype markdown inoremap<buffer> ,a [](<++>)<++><Esc>F[a
autocmd Filetype gitcommit inoremap<buffer> ,a [](<++>)<++><Esc>F[a

" for headers
autocmd Filetype markdown inoremap<buffer> ,1 #<Space>
autocmd Filetype gitcommit inoremap<buffer> ,1 #<Space>
autocmd Filetype markdown inoremap<buffer> ,2 ##<Space>
autocmd Filetype gitcommit inoremap<buffer> ,2 ##<Space>
autocmd Filetype markdown inoremap<buffer> ,3 ###<Space>
autocmd Filetype gitcommit inoremap<buffer> ,3 ###<Space>
autocmd Filetype markdown inoremap<buffer> ,4 ####<Space>
autocmd Filetype gitcommit inoremap<buffer> ,4 ####<Space>

" delete lines
autocmd Filetype markdown inoremap<buffer> ,d ~~~~<++><Esc>F~hi
autocmd Filetype gitcommit inoremap<buffer> ,d ~~~~<++><Esc>F~hi

" tilde
autocmd Filetype markdown inoremap<buffer> ,t ``<++><Esc>F`i
autocmd Filetype gitcommit inoremap<buffer> ,t ``<++><Esc>F`i

" math formulas
autocmd Filetype markdown inoremap<buffer> ,M <CR><CR>$$<CR><CR>$$<CR><CR><++><Esc>3kA
autocmd Filetype gitcommit inoremap<buffer> ,M <CR><CR>$$<CR><CR>$$<CR><CR><++><Esc>3kA

" math formulas in line
autocmd Filetype markdown inoremap<buffer> ,m $$<++><Esc>F$i
autocmd Filetype gitcommit inoremap<buffer> ,m $$<++><Esc>F$i

" newline but not new paragraph
autocmd FileType markdown inoremap<buffer> ,n <br><CR>
autocmd FileType gitcommit inoremap<buffer> ,n <br><CR>

" use mouse in markdown file,
" this is useful when you are write Chinese
" which is inconvenient to navigate with f/F or t/T.
autocmd FileType markdown set mouse+=a
autocmd FileType gitcommit set mouse+=a
" not used
" autocmd Filetype markdown inoremap<buffer> ,n ---<CR><CR>
" autocmd Filetype gitcommit inoremap<buffer> ,n ---<CR><CR>
" autocmd Filetype markdown inoremap<buffer> ,l --------<CR>
" autocmd Filetype gitcommit inoremap<buffer> ,l --------<CR>
" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue

