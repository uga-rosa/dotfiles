" Disable mouse click for all mode
for mode in ['', 'i', 'c', 't']
  for pos in ['Left', 'Right', 'Middle']
    exec printf("%snoremap <%sMouse> <Nop>", mode, pos)
    for pre in [2, 3, 4, 'S', 'C', 'A']
      exec printf("%snoremap <%s-%sMouse> <Nop>", mode, pre, pos)
    endfor
  endfor
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
