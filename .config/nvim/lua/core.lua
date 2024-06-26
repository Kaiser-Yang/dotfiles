vim.cmd [[
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable
set foldtext='+--'

set ttimeoutlen=0

set mouse=a
set mousemoveevent

set number
set relativenumber
set laststatus=2
set showtabline=2
set display=lastline
set scrolloff=5
set colorcolumn=100
set signcolumn=yes
set cursorline
set showcmd
set wildmenu
set wildmode=longest:full,full

set list
set listchars=tab:»·,trail:·,lead:·

set autochdir

autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

set ignorecase
set smartcase
set incsearch
set hlsearch

exec "nohlsearch"

set expandtab
set tabstop=4
set softtabstop=0
set shiftwidth=4

set cinwords=if,else,switch,case,for,while,do
set cinoptions=j1,(0,ws,Ws,g0,:0,=0,l1

set showbreak=↪

set switchbuf=useopen

set wrap
set breakindent
set tw=0

set termguicolors

set encoding=utf-8

set updatetime=100
]]

-- hi Normal guibg=none
-- set clipboard+=unnamedplus
-- set exrc

vim.cmd [[
augroup disable_formatoptions_cro
autocmd!
autocmd FileType * setlocal formatoptions-=cro
augroup end
]]

-- disable mouse when open telescope
-- we do this because mouse events in telescope will close the window
vim.cmd([[autocmd! FileType TelescopePrompt setlocal mouse=]])
vim.cmd([[autocmd! BufEnter * if &filetype !~ 'TelescopePrompt' | set mouse=a | endif]])
-- whether or not to disable swap file warning
-- vim.cmd [[
-- augroup disable_swap_exists_warning
-- autocmd!
-- autocmd SwapExists * let v:swapchoice = "e"
-- augroup end
-- ]]

-- vim.cmd [[
-- augroup neogit_setlocal
-- autocmd!
-- autocmd FileType NeogitStatus set foldtext='+--'
-- augroup END
-- ]]

-- vim.cmd [[
-- augroup quickfix_setlocal
-- autocmd!
-- autocmd FileType qf setlocal wrap
-- autocmd FileType qf vnoremap <buffer> <F6> <cmd>cclose<CR>
-- autocmd FileType qf nnoremap <buffer> <F6> <cmd>cclose<CR>
-- autocmd FileType qf vnoremap <buffer> <F18> <cmd>cclose<CR>
-- autocmd FileType qf nnoremap <buffer> <F18> <cmd>cclose<CR>
-- augroup END
-- ]]

-- vim.cmd [[
-- colorscheme gruvbox
-- " hi NormalFloat guifg=#928374 guibg=#282828
-- " hi WinSeparator guibg=none
-- " hi TreesitterContext gui=NONE guibg=#282828
-- " hi TreesitterContextBottom gui=underline guisp=Grey
-- ]]

-- vim.g_printed = ''
-- vim.g_print = function(msg)
--     vim.g_printed = vim.g_printed .. tostring(msg) .. '\n'
-- end
-- vim.g_dump = function()
--     print(vim.g_printed)
-- end

