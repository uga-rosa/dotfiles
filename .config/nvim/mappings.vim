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

xnoremap * "my/\V<C-r><C-r>=substitute(escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>N

nmap gj gj<SID>g
nmap gk gk<SID>g
nnoremap <script> <SID>gj gj<SID>g
nnoremap <script> <SID>gk gk<SID>g
nmap <SID>g <Nop>

nmap <C-w>+ <C-w>+<SID>ws
nmap <C-w>- <C-w>-<SID>ws
nmap <C-w>< <C-w><<SID>ws
nmap <C-w>> <C-w>><SID>ws
nnoremap <script> <SID>ws+ <C-w>+<SID>ws
nnoremap <script> <SID>ws- <C-w>-<SID>ws
nnoremap <script> <SID>ws< <C-w><<SID>ws
nnoremap <script> <SID>ws> <C-w>><SID>ws
nmap <SID>ws <Nop>

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
