" File-content encoding for the current buffer.
set fileencoding='utf-8'

" Used for the CursorHold autocommand event.
set updatetime=100

" When off a buffer is unloaded (including loss of undo information) when it is abandoned.
set hidden

set number

set showmatch

" Number of spaces that a <Tab> in the file counts for.
set tabstop=4
" Number of spaces to use for each step of (auto)indent.
set shiftwidth=4
" Use the appropriate number of spaces to insert a <Tab>.
set expandtab

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

set cedit=\<C-g>

set mouse=a
map <LeftMouse> <Nop>
imap <LeftMouse> <Nop>
map <2-LeftMouse> <Nop>
imap <2-LeftMouse> <Nop>

let g:do_filetype_lua = 1
let g:did_load_filetypes = 0

augroup zenhan
    au!
    au InsertLeave * :call system('zenhan.exe 0')
augroup END

augroup my_filetype
    au!
    au BufNewFile,BufRead *.ahk set ft=autohotkey
    au BufNewFile,BufRead *.inp set ft=packmol
    au BufNewFile,BufRead *.nim set ft=nim
augroup END

command! ShowHlGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
