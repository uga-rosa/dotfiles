let mapleader = "\<Space>"

call plug#begin('~/.vim/plugged')
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'kana/vim-operator-user'
Plug 'kana/vim-operator-replace'
Plug 'itchyny/lightline.vim'
Plug 'myusuf3/numbers.vim'
Plug 'junegunn/vim-easy-align'
call plug#end()

set termguicolors
colorscheme nightfly
let g:lightline = {'colorscheme': 'nightfly'}

set fileencoding=utf-8
set fileformats=unix,dos,mac
set hidden
set title
set number
set showmatch
set cursorline
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=2
set smartindent
set autoread
set noswapfile
set nobackup
set noundofile
set showcmd
set scrolloff=3
set ignorecase
set smartcase
set backspace=indent,eol,start
set shell=/bin/zsh
set timeoutlen=1000 ttimeoutlen=0
set wildmenu
set laststatus=2

" cursor shape
if has('vim_starting')
    let &t_SI .= "\e[6 q"
    let &t_EI .= "\e[2 q"
    let &t_SR .= "\e[4 q"
endif

autocmd FileType * setlocal formatoptions-=ro

nnoremap <silent> <leader><esc> <cmd>noh<cr>

vnoremap < <gv
vnoremap > >gv

nnoremap <leader><cr> o<esc>

cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>

inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-d> <Del>

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

nnoremap x "_x
nnoremap s "_s
xnoremap p "_xP

noremap H ^
noremap L $

nnoremap Y y$

nnoremap f<C-j> f、
nnoremap f<C-k> f。
nnoremap F<C-j> F、
nnoremap F<C-k> F。
nnoremap t<C-j> t、
nnoremap t<C-k> t。
nnoremap T<C-j> T、
nnoremap T<C-k> T。

" vim-operator-replace
nmap _ <Plug>(operator-replace)

" vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
