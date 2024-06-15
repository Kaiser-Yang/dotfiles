let g:copilot_no_tab_map = v:true
let g:copilot_no_maps = v:true

function! CopilotVisible()
    let s = copilot#GetDisplayedSuggestion()
    if !empty(s.text)
        return 1
    endif
    return 0
endfunction

imap <script><silent><expr> <ESC>f CopilotVisible() ? copilot#AcceptWord() : "\<ESC>f"

" Tab key can be used to accept the suggestion
inoremap <script><silent><expr> <TAB> CopilotVisible() ? copilot#Accept() : "\<TAB>"
