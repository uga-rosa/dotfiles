packadd vim-jetpack
call jetpack#begin()
Jetpack 'tani/vim-jetpack', {'opt': 1}
Jetpack 'vim-denops/denops.vim'
Jetpack 'uga-rosa/denippet.vim', {'dir': '~/plugin/denippet.vim'}
call jetpack#end()

" denippet.vim
for file in glob(expand('~/.config/nvim/snippets/') . '*.toml', 1, 1)
  call denippet#load(file)
endfor
inoremap <C-l> <Plug>(denippet-expand)
inoremap <expr> <Tab> denippet#jumpable() ? '<Plug>(denippet-jump-next)' : '<Tab>'
snoremap <expr> <Tab> denippet#jumpable() ? '<Plug>(denippet-jump-next)' : '<Tab>'
inoremap <expr> <S-Tab> denippet#jumpable(-1) ? '<Plug>(denippet-jump-prev)' : '<S-Tab>'
snoremap <expr> <S-Tab> denippet#jumpable(-1) ? '<Plug>(denippet-jump-prev)' : '<S-Tab>'

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

colorscheme habamax

" cursor shape
if has('vim_starting')
  let &t_SI .= "\e[6 q"
  let &t_EI .= "\e[2 q"
  let &t_SR .= "\e[4 q"
endif

autocmd FileType * setlocal formatoptions-=ro

for mode in ['n', 'v', 'o', 'i', 'c', 't']
  execute mode . 'noremap : ;'
  execute mode . 'noremap ; :'
endfor

nnoremap <silent> <esc><esc> <cmd>noh<cr>
nnoremap <space><cr> o<esc>

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
