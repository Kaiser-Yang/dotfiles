" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.

" cos-json is recommended strongly, this can help you write coc-settings.json
" others depend on what you need
let g:coc_global_extensions = ['coc-json', 'coc-clangd', 'coc-git', 'coc-pyright', 'coc-json', 'coc-html', 'coc-css', 'coc-word', 'coc-syntax', 'coc-cmake', 'coc-clang-format-style-options', 'coc-sh', 'coc-yaml', 'coc-diagnostic', 'coc-snippets']

" some extensions are introduced below:
" 1. coc-clang-format-options
" This will help you when you write .clang-format
" Use this fro ruzzy searching :CocList clang_format_style_options

" 2. coc-git
" This will show the git status at left, and enable you to navigate between changes and conflicts
" Those configurations are for coc-git
" Navigate chunks of current buffer
nnoremap [g <Plug>(coc-git-prevchunk)
nnoremap ]g <Plug>(coc-git-nextchunk)
" Navigate conflicts of current buffer
nnoremap [c <Plug>(coc-git-prevconflict)
nnoremap ]c <Plug>(coc-git-nextconflict)
" show chunk diff at current position
nnoremap <leader>gdf <Plug>(coc-git-chunkinfo)
" show commit contains current position
nnoremap <leader>gcm <Plug>(coc-git-commit)
" I don't use this now
" create text object for git chunks
" onoremap ig <Plug>(coc-git-chunk-inner)
" xnoremap ig <Plug>(coc-git-chunk-inner)
" onoremap ag <Plug>(coc-git-chunk-outer)
" xnoremap ag <Plug>(coc-git-chunk-outer)

" the length of completion menu
set pumheight=30

" use C-j and C-k to navigate
inoremap <silent><expr> <C-j>
    \ coc#pum#visible() ? coc#pum#next(1) :
    \ "\<C-j>"
inoremap <silent><expr> <C-k>
    \ coc#pum#visible() ? coc#pum#prev(1) :
    \ "\<C-k>"

" use tab and s-tab to navigate in code snippets
let g:coc_snippet_next="<TAB>"
let g:coc_snippet_prev="<S-TAB>"

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" use <C-c> to cancel a completion
inoremap <silent><expr> <C-c> coc#pum#visible() ? coc#pum#cancel() : "\<C-c>"

" d for diagnostics
" Use `[d` and `]d` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nnoremap <silent> [d <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]d <Plug>(coc-diagnostic-next)

" GoTo code navigation
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gh :CocCommand clangd.switchSourceHeader<CR>

" use H to quix fix error
nnoremap H <Plug>(coc-fix-current)

" use <leader>i to toggle inlay hints
" close by default is better, but I don't know how to set
nnoremap <leader>i :<C-u>CocCommand document.toggleInlayHint<CR>

" Use <leader>d to show documentation in preview window
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  endif
endfunction
nnoremap <silent> <Leader>d :call ShowDocumentation()<CR>

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Formatting selected code
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)
" augroup mygroup
"   autocmd!
"   " Setup formatexpr specified filetype(s)
"   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"   " Update signature help on jump placeholder
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end

" rename current symbol
nmap <leader>R <Plug>(coc-rename)

" I don't know how to use this now
" xnoremap <silent> <leader>R <Plug>(coc-codeaction-refactor-selected)
" nnoremap <silent> <leader>R <Plug>(coc-codeaction-refactor)

" Run the Code Lens action on the current line
" this is not supported by my vim version
" nmap <leader>g  <Plug>(coc-codelens-action)

" use <leader>ll to use CocList
" NOTE: do not remove the trail whitespace
nnoremap <leader>ll  :<C-u>CocList 

" use <leader>cmd to fuzzy find for commands
nnoremap <leader>cmd :<C-u>CocList commands<CR>

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue

