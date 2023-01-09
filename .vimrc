set rtp+=~/.cache/dein/repos/github.com/vim-denops/denops.vim
set rtp+=~/plugin/scorpeon.vim
let g:scorpeon_extensions_path = [
      \ expand('~/.cache/scorpeon'),
      \ expand('~/.cache/vscode/extensions')
      \ ]
let g:scorpeon_highlight = { 'enable': v:true }

packadd vim-jetpack
call jetpack#begin()
Jetpack 'tani/vim-jetpack', {'opt': 1}
Jetpack 'vim-denops/denops.vim'
Jetpack 'yuki-yano/fuzzy-motion.vim'
Jetpack 'vim-skk/skkeleton'
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

" Fuzzy motion
nmap ss <Cmd>FuzzyMotion<CR>

" skkeleton
inoremap <C-j> <Plug>(skkeleton-toggle)
cnoremap <C-j> <Plug>(skkeleton-toggle)

call add(g:skkeleton#mapped_keys, '<c-l>')
call skkeleton#register_keymap('input', '<c-q>', 'katakana')
call skkeleton#register_keymap('input', '<c-l>', 'zenkaku')
call skkeleton#register_keymap('input', "'", 'henkanPoint')
call skkeleton#register_kanatable('azik',
      \ json_decode(join(readfile(expand('~/.config/nvim/script/azik.json')))), v:true)

call skkeleton#config(#{
      \ kanaTable: 'azik',
      \ eggLikeNewline: v:true,
      \ globalDictionaries: [
      \   '~/.skk/SKK-JISYO.L',
      \   '~/.skk/SKK-JISYO.edict2',
      \ ],
      \ markerHenkan: '<>',
      \ markerHenkanSelect: '>>',
      \ registerConvertResult: v:true,
      \ })

augroup my_skkeleton
  au!
  au User skkeleton-enable-post  call s:show_mode_enable()
  au User skkeleton-disable-post call s:show_mode_disable()
augroup END

call prop_type_add('show_mode', #{ highlight: 'PMenuSel' })

function! s:show_mode_enable() abort
  au my_skkeleton CursorMovedI * call s:show_mode_update()
endfunction

function! s:show_mode_update() abort
  call prop_remove(#{ type: 'show_mode' })
  call prop_add(line('.'), 0, #{
        \ type: 'show_mode',
        \ text: skkeleton#mode(),
        \ text_align: 'after',
        \ })
endfunction

function! s:show_mode_disable() abort
  au! my_skkeleton CursorMovedI
  call prop_remove(#{ type: 'show_mode' })
endfunction
