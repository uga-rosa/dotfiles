" This configuration does not take into account anything other than
" neovim in unix.

let mapleader = "\<Space>"

lua <<EOL
pcall(require, "impatient")
require("utils")
require("rc.autocmd")
require("rc.ftdetect")
EOL

if filereadable(expand('~/.secret.vim'))
  source ~/.secret.vim
endif

let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif

" Bootstrap of dein.vim
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = $CACHE . '/dein/repos/github.com/Shougo/dein.vim'
  if !isdirectory(s:dein_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_dir, ':p')
endif

let g:dein#auto_recache = v:true

let g:dein#lazy_rplugins = v:true
let g:dein#install_progress_type = 'floating'
let g:dein#install_check_diff = v:true
let g:dein#enable_notification = v:true
let g:dein#install_check_remote_threshold = 24 * 60 * 60
let g:dein#auto_remote_plugins = v:false
let g:dein#install_copy_vim = v:true

let s:path = $CACHE . '/dein'
if dein#min#load_state(s:path)
  let s:base_dir = fnamemodify(expand('<sfile>'), ':h') . '/rc/'

  let g:dein#inline_vimrcs = ['options.vim', 'mappings.vim']
  let g:dein#inline_vimrcs = map(g:dein#inline_vimrcs, { _, v -> s:base_dir . v })

  let s:dein_toml = s:base_dir . 'dein.toml'
  let s:dein_lazy_toml = s:base_dir . 'deinlazy.toml'
  let s:dein_ft_toml = s:base_dir . 'deinft.toml'
  let s:dein_lsp_toml = s:base_dir . 'deinlsp.toml'
  let s:cmp_toml = s:base_dir . 'cmp.toml'
  let s:scorpeon_toml = s:base_dir . 'scorpeon.toml'

  call dein#begin(s:path)

  call dein#load_toml(s:dein_toml, {'lazy': 0})
  call dein#load_toml(s:dein_lazy_toml, {'lazy' : 1})
  call dein#load_toml(s:dein_ft_toml, {'lazy' : 1})
  call dein#load_toml(s:dein_lsp_toml, {'lazy' : 1})
  call dein#load_toml(s:cmp_toml, {'lazy' : 1})
  call dein#load_toml(s:scorpeon_toml, {'lazy' : 1})

  call dein#end()
  call dein#save_state()
endif

call dein#call_hook('source')
autocmd VimEnter * call dein#call_hook('post_source')

if dein#check_install()
  call dein#install()
endif

command! -nargs=0 DeinUpdate call s:update()
function! s:update() abort
  if exists('g:dein#install_github_api_token')
    call dein#check_update(v:true)
  else
    call dein#update()
  endif
endfunction
