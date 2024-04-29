" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.
" turn off trim white spaces when saving files
let g:pymode_trim_whitespaces = 0

" do not use default setting for python files
" because will set nowrap and so on
let g:pymode_options = 0

" disable colorcolumn display
let g:pymode_options_colorcolumn = 0

" python version
let g:pymode_python = 'python3'

" disable pymode-motion
let g:pymode_motion = 0

" turn off pymode_doc, we can use <leader>d to see docs with ycm
let g:pymode_doc = 0

" turn off run code with this plugin
let g:pymode_run = 0

" turn off break points
let g:pymode_breakpoint = 0

" check code when editing
let g:pymode_lint_on_fly = 1

" default checker
let g:pymode_lint_checkers = ['pyflakes']

" disalbe window to show errors
let g:pymode_lint_cwindow = 0

" the default symbols, you can modify them
let g:pymode_lint_todo_symbol = 'WW'
let g:pymode_lint_comment_symbol = 'CC'
let g:pymode_lint_visual_symbol = 'RR'
let g:pymode_lint_error_symbol = '>>'
let g:pymode_lint_info_symbol = 'II'
let g:pymode_lint_pyflakes_symbol = 'FF'

" turn rope support
let g:pymode_rope = 0

" turn off auto comletion
let g:pymode_rope_completion = 0

" turn off pymode syntax
let g:pymode_syntax = 0

" disable some key bindings
let g:pymode_rope_show_doc_bind = ''
let g:pymode_rope_goto_definition_bind = ''
let g:pymode_rope_rename_bind = ''
let g:pymode_rope_rename_module_bind = ''
let g:pymode_rope_organize_imports_bind = ''
let g:pymode_rope_autoimport_bind = ''
let g:pymode_rope_module_to_package_bind = ''
let g:pymode_rope_extract_method_bind = ''
let g:pymode_rope_extract_variable_bind = ''
let g:pymode_rope_use_function_bind = ''
let g:pymode_rope_move_bind = ''
let g:pymode_rope_change_signature_bind = ''

" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue

