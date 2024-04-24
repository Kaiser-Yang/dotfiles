
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.
" vim YouCompleteMe config

" use <F5> to refresh
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>

" use gd to go to definition
nnoremap gd :YcmCompleter GoTo<CR>

" nnoremap gh <Nop>
nnoremap gh :YcmCompleter GoToAlternateFile<CR>

" use gr to go to references
nnoremap gr :YcmCompleter GoToReferences<CR>

" use gc to go to callers, find those who call this function
nnoremap gc :YcmCompleter GoToCallers<CR>

" use <Leader>R to refactor rename
nnoremap <Leader>R :YcmCompleter RefactorRename 

" use <Ctrl-f> as fix it command
nnoremap <C-f> :YcmCompleter FixIt<CR>

" use <Leader>d show doc for current symbol
nnoremap <Leader>d <plug>(YCMHover)

let g:ycm_extra_conf_globlist = ['~/.vim/vim_plugin_config/ycm_extra_config_global.py']
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
" don't complete in comments, this will trigger every time you input .
" let g:ycm_complete_in_comments = 1
" let g:ycm_complete_in_strings = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_list_select_completion = ['<C-j>', '<TAB>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<S-TAB>']
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_auto_hover = ''
let g:ycm_enable_semantic_highlighting = 1

" add # to trigger for C-family language
" input two characters will trigger ycm for c and cpp files
let g:ycm_semantic_triggers =  {
    \   'c': ['->', '.', '#', 're!w{2}'],
    \   'objc': ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
    \            're!\[.*\]\s'],
    \   'ocaml': ['.', '#'],
    \   'cpp,cuda,objcpp': ['->', '.', '::', '#', 're!w{2}'],
    \   'perl': ['->'],
    \   'php': ['->', '::'],
    \   'cs,d,elixir,go,groovy,java,javascript,julia,perl6,python,scala,typescript,vb': ['.'],
    \   'ruby,rust': ['.', '::'],
    \   'lua': ['.', ':'],
    \   'erlang': [':'],
    \ }

" let ycm complete markdown files
let g:ycm_filetype_blacklist = {
    \ 'tagbar': 1,
    \ 'notes': 1,
    \ 'netrw': 1,
    \ 'unite': 1,
    \ 'text': 1,
    \ 'pandoc': 1,
    \ 'infolog': 1,
    \ 'leaderf': 1,
    \ 'mail': 1
    \}
" You can use this line to let <CR> close completion,
" which is similar with vscode.
" let g:ycm_key_list_stop_completion = ['<C-y>', '<CR>']

" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue
