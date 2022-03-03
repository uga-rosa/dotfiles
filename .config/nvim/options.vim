set fileencoding='utf-8'
set updatetime=100
set hidden
set number
set showmatch
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set noswapfile
set scrolloff=3
set ignorecase
set smartcase
set pumheight=25
set termguicolors
set nofoldenable
set clipboard+=unnamedplus
set inccommand=split
set signcolumn=yes

let g:do_filetype_lua = 1
let g:did_load_filetypes = 0

augroup zenhan
    au!
    au InsertLeave * :call system('zenhan.exe 0')
    au CmdlineLeave * :call system('zenhan.exe 0')
augroup END

augroup my_filetype
    au!
    au BufNewFile,BufRead *.ahk set ft=autohotkey
    au BufNewFile,BufRead *.inp set ft=packmol
augroup END
