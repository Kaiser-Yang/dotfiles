
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.

" Set no compatible mode for vim
set nocompatible

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
set shortmess+=I


" set line number
set number
" Set relative line number
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Unbind some useless/annoying default key bindings.
" 'Q' in normal mode enters Ex mode. You almost never want this.
" we map Q to be :q
nmap Q <Nop> 
nnoremap Q :q<CR>
" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ^P to open CtrlP pluggin
let g:ctrlp_map = '<C-p>'

let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
\ 'dir':  '\v[\/]\.(git|hg|svn)$',
\ 'file': '\v\.(exe|so|dll)$',
\ }
" let dot files be included in ctrlp
let g:ctrlp_show_hidden = 1
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>
" show cursor line to let you know where are you now more efficiently
set cursorline
" show command
set showcmd
" wild menu for tab search
set wildmenu
" set indentation 4 spaces
set expandtab
set tabstop=4
set shiftwidth=4
" set wrap for split lines automatically
set wrap
" set S to be :w, because S is synonym for cc
map S :w<CR>
" set ^N and ^B to navigate between tabs
nnoremap <C-n> :tabnext<CR>
nnoremap <C-b> :tabprev<CR>
inoremap <C-n> <ESC>:tabnext<CR>
inoremap <C-b> <ESC>:tabprev<CR>
" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue
