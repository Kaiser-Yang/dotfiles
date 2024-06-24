
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.
let g:vimwiki_list = [
\ {
    \ 'path_html': '/mnt/e/vimwiki/programming/html',
    \ 'path': '/mnt/e/vimwiki/programming',
    \ 'syntax': 'markdown',
    \ 'ext':'.md',
    \ 'custom_wiki2html': '~/.vim/autoload/wiki2html.sh'
\ },
\ {
    \ 'path_html': '/mnt/e/vimwiki/blog/html',
    \ 'path': '/mnt/e/vimwiki/blog',
    \ 'syntax': 'markdown',
    \ 'ext':'.md',
    \ 'custom_wiki2html': '~/.vim/autoload/wiki2html.sh'
\ }]

" disable html convertion default key bindings.
let g:vimwiki_key_mappings =
    \ {
    \   'all_maps': 1,
    \   'global': 1,
    \   'headers': 1,
    \   'text_objs': 1,
    \   'table_format': 1,
    \   'table_mappings': 1,
    \   'lists': 1,
    \   'links': 1,
    \   'html': 0,
    \   'mouse': 0,
    \   'lists_return': 0
    \ }

" treat all .md files as vimwiki
" this will make input in markdown files more easily
let g:vimwiki_global_ext = 1

" do not format table last column
let g:vimwiki_table_reduce_last_col = 1

" you should not let a single markdown file be seen as vimwiki,
" and you should not add links for that,
" if you want another index, you should add another config.
let g:vimwiki_ext2syntax = {}

" don't conceal links
let g:vimwiki_conceallevel = 0

" remap lists_return
autocmd FileType vimwiki inoremap <silent><buffer><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
              \: CopilotVisible() ? copilot#Accept() : "\<C-]>\<Esc>:VimwikiReturn 3 5\<CR>"
autocmd FileType vimwiki inoremap <silent><buffer> <S-CR>
              \ <Esc>:VimwikiReturn 2 2<CR>

" use <LEADER>wh convert all files to html files
autocmd Filetype vimwiki nnoremap <LEADER>wh :VimwikiAll2HTML<CR>
" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue

