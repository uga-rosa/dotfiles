" Disable mouse click for all mode
for mode in ['', 'i', 'c', 't']
  exec mode . 'noremap <LeftMouse> <Nop>'
  exec mode . 'noremap <2-LeftMouse> <Nop>'
  exec mode . 'noremap <RightMouse> <Nop>'
  exec mode . 'noremap <2-RightMouse> <Nop>'
endfor

" Release for prefix
nnoremap s <Nop>

" Go to first/end line
noremap <expr> H getline('.')[:col('.')-2] =~# '\v^\s+$' ? '0' : '^'
sunmap H
noremap L $
sunmap L

" Easy to see o/O
nnoremap o zzo
nnoremap O zzO

" Insert blank line
nnoremap <leader><CR>         o<Esc>
nnoremap <leader><leader><CR> O<Esc>

" no highlight
nnoremap <Esc><Esc> <Cmd>nohl<CR>

" Visual indent/dedent
xnoremap < <gv
xnoremap > >gv

" Erase x history
nnoremap x "_x

" Emacs keybinding
" Insert mode
inoremap <C-f> <C-g>U<Right>
inoremap <C-b> <C-g>U<Left>
inoremap <C-d> <Del>

" Command mode
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-h> <BS>
cnoremap <C-d> <Del>

" Close tab
nnoremap qt <Cmd>tabclose<CR>

" Macro
nnoremap Q @q
