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
nnoremap s "_s

nnoremap j  gj
nnoremap k  gk
nnoremap gj j
nnoremap gk k

inoremap <C-f>  <C-g>U<Right>
cnoremap <C-f>  <Right>
inoremap <C-b>  <C-g>U<Left>
cnoremap <C-b>  <Left>
cnoremap <C-a>  <Home>
cnoremap <C-e>  <End>
imap     <C-h>  <BS>
cnoremap <C-h>  <BS>
inoremap <C-d>  <Del>
cnoremap <C-d>  <Del>
cnoremap <expr> <C-x> expand('%:p')

" better escape
augroup better_escape
    au!
    au InsertCharPre * lua require("escape").escape()
    au InsertLeave * lua require("escape").leave()
augroup END
