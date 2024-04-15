
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.
" vim YouCompleteMe config

" use <F5> to refresh
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>

" use gd to go to definition
nnoremap gd <Nop>
nnoremap gd :rightbelow vertical YcmCompleter GoTo<CR>
" nnoremap gh  <Nop>
" nnoremap ghd <Nop>
" nnoremap ghd :leftabove vertical YcmCompleter GoTo<CR>
" nnoremap gj  <Nop>
" nnoremap gjd <Nop>
" nnoremap gjd :rightbelow YcmCompleter GoTo<CR>
" nnoremap gk  <Nop>
" nnoremap gkd <Nop>
" nnoremap gkd :leftabove YcmCompleter GoTo<CR>
" nnoremap gl  <Nop>
" nnoremap gld <Nop>
" nnoremap gld :rightbelow vertical YcmCompleter GoTo<CR>
" use gh to go to current file's header file

" nnoremap gh <Nop>
nnoremap gh :rightbelow vertical YcmCompleter GoToAlternateFile<CR>

" use gr to go to references
nnoremap gr <Nop>
nnoremap gr :rightbelow vertical YcmCompleter GoToReferences<CR>

" use gc to go to callers, find those who call this function
nnoremap gc <Nop>
nnoremap gc :rightbelow vertical YcmCompleter GoToCallers<CR>

" use <Leader>r to refactor rename
nnoremap <Leader>r :YcmCompleter RefactorRename 

" use <Ctrl-f> as fix it command
nnoremap <C-f> <Nop>
nnoremap <C-f> :YcmCompleter FixIt<CR>

" use <Leader>d show dow for current symbol
nnoremap <Leader>d <plug>(YCMHover)

let g:ycm_extra_conf_globlist = ['~/.vim/vim_plugin_config/ycm_extra_config_global.py']
let g:ycm_goto_buffer_command = 'split-or-existing-window'
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_list_select_completion = ['<C-j>', '<TAB>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<S-TAB>']
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_semantic_triggers =  {
  \   'c': ['->', '.', '#'],
  \   'cpp': ['->', '.', '#'],
  \   'objc': ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \            're!\[.*\]\s'],
  \   'ocaml': ['.', '#'],
  \   'cpp,cuda,objcpp': ['->', '.', '::'],
  \   'perl': ['->'],
  \   'php': ['->', '::'],
  \   'cs,d,elixir,go,groovy,java,javascript,julia,perl6,python,scala,typescript,vb': ['.'],
  \   'ruby,rust': ['.', '::'],
  \   'lua': ['.', ':'],
  \   'erlang': [':'],
  \ }
" You can use this line to let <CR> close completion,
" which is similar with vscode.
" let g:ycm_key_list_stop_completion = ['<C-y>', '<CR>']

" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue
