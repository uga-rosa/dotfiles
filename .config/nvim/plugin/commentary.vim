command! -range -bar -bang Commentary call commentary#go(<line1>,<line2>,<bang>0)
xnoremap <expr>   <Plug>Commentary     commentary#go()
nnoremap <expr>   <Plug>Commentary     commentary#go()
nnoremap <expr>   <Plug>CommentaryLine commentary#go() . '_'
onoremap <silent> <Plug>Commentary        :<C-U>call commentary#textobject(get(v:, 'operator', '') ==# 'c')<CR>
nnoremap <silent> <Plug>ChangeCommentary c:<C-U>call commentary#textobject(1)<CR>

xmap gc  <Plug>Commentary
nmap gc  <Plug>Commentary
omap gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine
nmap gcu <Plug>Commentary<Plug>Commentary
