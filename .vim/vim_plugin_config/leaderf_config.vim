
" start_symbol_kaiserqzyue
" We add a empty line above to make sure the script append it correctly.

" use popup rather than bottom.
let g:Lf_WindowPosition = 'popup'
let g:Lf_PopupHeight = 0.3
let g:Lf_PopupWidth = 0.75
let g:Lf_PopupPreviewPosition = 'top'

" the icons are all ?, may need some extensions,
" you should install nerd-font for your terminal.
let g:Lf_ShowDevIcons = 1

" use version control to find root directory
let g:Lf_WorkingDirectoryMode = 'AF'
let g:Lf_RootMarkers = ['.git', '.svn', '.hg', '.project', '.root']

" those will be ignored
let g:Lf_WildIgnore = {
    \ 'file': ['*.vcproj', '*.vcxproj', '*.exe', '*.so', '*.dll', '*.o', '*.obj', 'LICENSE'],
    \ 'dir': ['build', 'tmp', '.git']}

" show hidden files, this is helpful when you are editing configure files.
let g:Lf_ShowHidden = 1

" use ^P to open
let g:Lf_ShortcutF = '<C-P>'
inoremap <C-p> <Esc>:LeaderfFile<CR>

" when find symbols we don't ignore dotfiles,
" we'll ignore .git and LICENSE
let g:Lf_RgConfig = [
    \ "--hidden",
    \ "--glob=!.git/*",
    \ "--glob=!LICENSE",
\ ]

" we use <C-f> to find symbols in files.
nnoremap <C-f> :Leaderf rg<CR>
inoremap <C-f> <ESC>:Leaderf rg<CR>
" we add a empty line below to make sure the script append it coreectly.
" end_symbol_kaiserqzyue

