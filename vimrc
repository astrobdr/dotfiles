" BreakHere — split the current line at the cursor position.
" The opposite of J (join). Preserves indentation.
" Mapped to `gh` in normal mode.
"
" Example: with cursor at |
"   const foo = bar | + baz
" becomes:
"   const foo = bar
"   + baz
function! BreakHere()
    s/^\(\s*\)\(.\{-}\)\(\s*\)\(\%#\)\(\s*\)\(.*\)/\1\2\r\1\4\6
    call histdel("/", -1)
endfunction

nnoremap gh :<C-u>call BreakHere()<CR>

