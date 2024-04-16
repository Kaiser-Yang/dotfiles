
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.

" set scrolloff to make you can see the non-exist lines of files
" set scrolloff=999 will let your cursor line always be in the middle.
" but when it reach the bottom, the cursor line will not be the middle,
" use this below can figure it out, make your cursor always the middle,
augroup VCenterCursor
au!
au BufEnter,WinEnter,WinNew,VimResized *,*.*
    \ let &scrolloff=winheight(win_getid())/2
augroup END
nnoremap i zzi
nnoremap I zzI
nnoremap o zzo
nnoremap O zzO
nnoremap a zza
nnoremap A zzA

" Those are for wsl cursor to be changeable between normal mode and insert mode.
let &t_SI.="\e[5 q"
let &t_SR.="\e[3 q"
let &t_EI.="\e[1 q"
autocmd VimEnter * silent !echo -ne "\e[1 q"
autocmd VimLeave * silent !echo -ne "\e[5 q"

" This is to make <ESC> quicker
set ttimeoutlen=0

" use system clip board
set clipboard=unnamed

" set leader be space
nnoremap <space> <Nop>
vnoremap <space> <Nop>
let mapleader=" "

" set <leader>sc to turn on or off spell check
nnoremap <leader>sc :set spell!<CR>

" Set no compatible mode for vim
set nocompatible
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

" set utf-8 as default encoding
scriptencoding utf-8
set encoding=utf-8

" set list chars
set list
set listchars=tab:»·,trail:·

" set fold method for folding code.
set foldmethod=indent
set foldlevel=99

" set your working directory is where current file is.
set autochdir

" This is to set cursor where it was when the file is closed last time.
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
set shortmess+=I

" set line number
" Set relative line number
set number
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" We don't use backspace in normal and visual mode, use h instead.
nnoremap <BS> <Nop>
vnoremap <BS> <Nop>

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from
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

" highlight search
" use <LEADER><CR> to close search highlight
exec "nohlsearch"
set hlsearch
nnoremap <LEADER><CR> :nohlsearch<CR>

" Those two lines are for copy selected contents to Windows clipboard,
" or copy from Windows clipboard with <leader>c and <space>v
" those are mainly for wsl
" those can only copy or paste entire lines
vnoremap <LEADER>c :w !clip.exe<CR><CR>
nnoremap <LEADER>v :r !powershell.exe Get-Clipboard<CR>

" Unbind some useless/annoying default key bindings.
" 'Q' in normal mode enters Ex mode. You almost never want this.
" we map Q to be :q!
nmap Q <Nop>
nnoremap Q :q!<CR>

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
" set mouse+=a

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

" set ^S to be :w
nnoremap <C-s> <Nop>
nnoremap <C-s> :w<CR>

" set S to be :wq
nnoremap S <Nop>
nnoremap S :wq<CR>

" set <C> + h, j, k and l to be split left, down, up, right.
" set <leader> h, j, k and l to move cursor between Windows.
" set <leader>H, J, K, L to move current window to left, down, up, right
" set <leader>T to let current window be a new tab
nnoremap <C-h> :set nosplitright<CR>:vsplit<CR>:set splitright<CR>
nnoremap <C-j> :set splitbelow<CR>:split<CR>:set nosplitbelow<CR>
nnoremap <C-k> :set nosplitbelow<CR>:split<CR>
nnoremap <C-l> :set splitright<CR>:vsplit<CR>
inoremap <C-h> <ESC>:set nosplitright<CR><ESC>:vsplit<CR><ESC>:set splitright<CR>
" we can not use <C-j> in insert mode,
" because we use <C-j> to select code completion.
" inoremap <C-j> <ESC>:set splitbelow<CR><ESC>:split<CR><ESC>:set nosplitbelow<CR>
" inoremap <C-k> <ESC>:set nosplitbelow<CR><ESC>:split<CR>
inoremap <C-l> <ESC>:set splitright<CR><ESC>:vsplit<CR>
nnoremap <LEADER>h <C-w>h
nnoremap <LEADER>j <C-w>j
nnoremap <LEADER>k <C-w>k
nnoremap <LEADER>l <C-w>l
nnoremap <LEADER>H <C-w>H
nnoremap <LEADER>J <C-w>J
nnoremap <LEADER>K <C-w>K
nnoremap <LEADER>L <C-w>L
nnoremap <LEADER>T <C-w>T

" set up to add size of current window, down to minus size
" set right to add size of current window, left to minus size
nnoremap <Up> :res +5<CR>
nnoremap <Down> :res -5<CR>
nnoremap <Left> :vertical resize -5<CR>
nnoremap <Right> :vertical resize +5<CR>
inoremap <Up> <C-o>:res +5<CR>
inoremap <Down> <C-o>:res -5<CR>
inoremap <Left> <C-o>:vertical resize -5<CR>
inoremap <Right> <C-o>:vertical resize +5<CR>

" set ^T to create new tab
" set ^N and ^B to navigate between tabs
inoremap <C-t> <ESC>:tabnew<CR>
inoremap <C-n> <ESC>:tabnext<CR>
inoremap <C-b> <ESC>:tabprev<CR>
nnoremap <C-t> :tabnew<CR>
nnoremap <C-n> :tabnext<CR>
nnoremap <C-b> :tabprev<CR>

set completeopt=popup

source ~/.vim/vim_plugin_config/vimplug_config.vim
source ~/.vim/vim_plugin_config/ctrlp_config.vim
source ~/.vim/vim_plugin_config/youcompleteme_config.vim
source ~/.vim/vim_plugin_config/nerdtree_config.vim
source ~/.vim/vim_plugin_config/onedark_config.vim
source ~/.vim/vim_plugin_config/vimpolyglot_config.vim
source ~/.vim/vim_plugin_config/undotree_config.vim
" we add a empty line below to make sure the script append it correctly.
" end_symbol_kaiserqzyue

