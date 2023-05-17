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
  execute 'set runtimepath+=' . fnamemodify(s:dein_dir, ':p')
endif

let g:dein#auto_recache = v:true

let g:dein#lazy_rplugins = v:true
let g:dein#install_progress_type = 'floating'
let g:dein#enable_notification = v:true
let g:dein#install_check_remote_threshold = 24 * 60 * 60
let g:dein#install_max_processes = 100
let g:dein#auto_remote_plugins = v:false

let s:path = $CACHE . '/dein'
if dein#min#load_state(s:path)
  let s:base_dir = fnamemodify(expand('<sfile>'), ':h') . '/'

  let s:dein_toml = s:base_dir . 'dein.toml'
  let s:dein_lazy_toml = s:base_dir . 'dein_lazy.toml'
  let s:dein_lsp_toml = s:base_dir . 'lsp.toml'
  let s:cmp_toml = s:base_dir . 'cmp.toml'
  let s:dein_ft_toml = s:base_dir . 'ftplugin.toml'
  let s:ddu_toml = s:base_dir . 'ddu.toml'

  call dein#begin(s:path)

  call dein#load_toml(s:dein_toml)
  call dein#load_toml(s:dein_lazy_toml, {'lazy': 1})
  call dein#load_toml(s:dein_lsp_toml, {'lazy': 1})
  call dein#load_toml(s:cmp_toml, {'lazy': 1})
  call dein#load_toml(s:dein_ft_toml)
  call dein#load_toml(s:ddu_toml, {'lazy': 1})

  let s:work_dir = expand('~/plugin')
  if isdirectory(s:work_dir)
    call dein#local(s:work_dir,
          \ #{ frozen: 1, merged: 0 },
          \ [ 'vim*', 'nvim*', '*.vim', '*.nvim' ]
          \)
  endif

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on

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
