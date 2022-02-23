nnoremap <expr>   <Plug>Commentary     commentary#go()
xnoremap <expr>   <Plug>Commentary     commentary#go()
onoremap <silent> <Plug>Commentary     :<C-U>call commentary#textobject(get(v:, 'operator', '') ==# 'c')<CR>
nnoremap <expr>   <Plug>CommentaryLine commentary#go() . '_'

nmap gc  <Plug>Commentary
xmap gc  <Plug>Commentary
omap gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine
