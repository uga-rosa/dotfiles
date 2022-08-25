packadd vim-jetpack
call jetpack#begin()
Jetpack 'tani/vim-jetpack', {'opt': 1}
Jetpack 'vim-denops/denops.vim'
Jetpack 'yuki-yano/fuzzy-motion.vim'
call jetpack#end()

let mapleader = "\<Space>"

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

nnoremap <silent> <esc><esc> <cmd>noh<cr>
nnoremap <leader><cr> o<esc>

vnoremap < <gv
vnoremap > >gv

cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Del>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

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

" denops.vim
let g:denops_server_addr = '127.0.0.1:32123'
let s:denops_path = jetpack#get('denops.vim').path
call job_start(
\   'deno run -A --no-check ' . s:denops_path . '/denops/@denops-private/cli.ts',
\   {'stoponexit': ''}
\)

" Fuzzy motion
nmap ss <Cmd>FuzzyMotion<CR>
