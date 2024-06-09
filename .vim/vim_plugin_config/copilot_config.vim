let g:copilot_proxy = 'http://localhost:7890'
let g:copilot_no_tab_map = v:true
let g:copilot_no_maps = v:true
" for terminal that is in 7 bit mode
imap <script><silent><expr> f copilot#AcceptWord()

