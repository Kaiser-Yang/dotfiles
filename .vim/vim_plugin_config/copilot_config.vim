let g:copilot_no_tab_map = v:true
let g:copilot_no_maps = v:true

" for terminal that is in 7 bit mode
imap <script><silent><expr> f copilot#AcceptWord()

function! CopilotVisible()
    let s = copilot#GetDisplayedSuggestion()
    if !empty(s.text)
        return 1
    endif
    return 0
endfunction

inoremap <script><silent><expr> <TAB> CopilotVisible() ? copilot#Accept() : "\<TAB>"
