
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.
" onedark.vim override: Don't set a background color when running in a terminal;
" just use the terminal's background color
" `gui` is the hex color code used in GUI mode/nvim true-color mode
" `cterm` is the color code used in 256-color mode
" `cterm16` is the color code used in 16-color mode
if (has("autocmd") && !has("gui_running"))
  augroup colorset
    autocmd!
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
    " `bg` will not be styled since there is no `bg` setting
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white })
  augroup END
endif
colorscheme onedark
" this is for highlight selection
" because after setting transparent onedark's
" selection is nearly invisible, so just need this configure,
" you can set what color you like, ctermfg is the text color
hi visual ctermfg=white
hi visualblock guibg=gray
hi visualline guibg=gray
" we add a empty line below to make sure the script append it correctly
" end_symbol_kaiserqzyue

