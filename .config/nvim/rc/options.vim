set fileencoding=utf-8

set updatetime=100

set number
set signcolumn=yes

set showmatch

set tabstop=2
set shiftwidth=2

set expandtab
set smartindent
set noswapfile
set scrolloff=3

set ignorecase
set smartcase

set pumheight=25

set nowrap

" true color
set termguicolors

" 折り畳みは使わない
set nofoldenable

" :s などのプレビューが出る
set inccommand=split

" クリックはrc/mappings.vimで無効化
set mouse=ni

" ステータスラインを下だけに
set laststatus=3

" jaxしかないプラグインもある
set helplang=en,ja

" クリップボード連携
set clipboard=unnamedplus

" vimgrep
set grepprg=rg\ --vimgrep

" Disable unused provider
let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
