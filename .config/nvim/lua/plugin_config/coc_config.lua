vim.g.coc_global_extensions = {
  'coc-json',
  'coc-clangd',
  'coc-git',
  'coc-pyright',
  'coc-word',
  'coc-cmake',
  'coc-clang-format-style-options',
  'coc-sh',
  'coc-snippets',
  'coc-java',
  'coc-vimlsp',
  'coc-lua',
  'coc-yank',
  'coc-actions',
  'coc-marketplace',
--   'coc-python',
--   'coc-lightbulb',
--   'coc-html',
--   'coc-css',
--   'coc-syntax',
--   'coc-yaml',
--   'coc-diagnostic',
--   '@hexuhua/coc-copilot',
}

-- " Formatting selected code
-- " xmap <leader>f  <Plug>(coc-format-selected)
-- " nmap <leader>f  <Plug>(coc-format-selected)
-- " augroup mygroup
-- "   autocmd!
-- "   " Setup formatexpr specified filetype(s)
-- "   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
-- "   " Update signature help on jump placeholder
-- "   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
-- " augroup end

-- " I don't know how to use this now
-- " xnoremap <silent> <leader>R <Plug>(coc-codeaction-refactor-selected)
-- " nnoremap <silent> <leader>R <Plug>(coc-codeaction-refactor)

-- " Run the Code Lens action on the current line
-- " this is not supported by my vim version
-- " nmap <leader>g  <Plug>(coc-codelens-action)

-- " Add `:Format` command to format current buffer
-- command! -nargs=0 Format :call CocActionAsync('format')
--
-- " Add `:Fold` command to fold current buffer
-- " command! -nargs=? Fold :call CocAction('fold', <f-args>)
-- " nnoremap <leader>f :<C-u>Fold<CR>

-- autocmd CursorHold * silent call CocActionAsync('highlight')
