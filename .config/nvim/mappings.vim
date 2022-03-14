" for prefix
nnoremap s <Nop>
nnoremap m <Nop>

nnoremap H ^
xnoremap H ^
onoremap H ^
nnoremap L $
xnoremap L $
onoremap L $

nnoremap o zzo
nnoremap O zzO

nnoremap <leader><CR> o<Esc>
nnoremap <leader><C-CR> O<Esc>

nnoremap <Esc><Esc> <cmd>nohlsearch<CR>

vnoremap < <gv
vnoremap > >gv

nnoremap + <C-a>
nnoremap - <C-x>

nnoremap x "_x

nnoremap j  gj
nnoremap k  gk
nnoremap gj j
nnoremap gk k

" Emacs key binding
inoremap <C-f>  <C-g>U<Right>
inoremap <C-b>  <C-g>U<Left>
inoremap <C-d>  <Del>

cnoremap <C-f>  <Right>
cnoremap <C-b>  <Left>
cnoremap <C-a>  <Home>
cnoremap <C-e>  <End>
cnoremap <C-h>  <BS>
cnoremap <C-d>  <Del>
cnoremap <expr> <C-x> expand('%:p')

" better escape
augroup better_escape
    au!
    au InsertCharPre * lua require("escape").escape()
    au InsertLeave * lua require("escape").leave()
augroup END
