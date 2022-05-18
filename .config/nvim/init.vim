let mapleader = ' '

lua require('utils')

if filereadable(expand('~/.secret.vim'))
    source ~/.secret.vim
endif

" Load dein.vim
if &runtimepath !~# '/dein.vim'
    let s:dein_dir = fnamemodify('dein.vim', ':p')
    if !isdirectory(s:dein_dir)
        let s:dein_dir = expand('~/.cache') . '/dein/repos/github.com/Shougo/dein.vim'
        if !isdirectory(s:dein_dir)
            execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
        endif
    endif
    execute 'set runtimepath^=' . substitute(fnamemodify(s:dein_dir, ':p'), '[/\\]$', '', '')
endif

let g:dein#install_progress_type = 'floating'
let g:dein#auto_recache = v:true

let s:path = expand('~/.cache') . '/dein'
if dein#min#load_state(s:path)
    let g:dein#inline_vimrcs = [stdpath('config') . '/options.vim', stdpath('config') . '/mappings.vim']

    let s:base_dir = stdpath('config') . '/'

    call dein#begin(s:path)

    let s:dein_toml = s:base_dir . 'dein.toml'
    let s:dein_status_toml = s:base_dir . 'status.toml'
    let s:dein_lazy_toml = s:base_dir . 'deinlazy.toml'
    let s:dein_cmp_toml = s:base_dir . 'cmp.toml'
    let s:dein_lsp_toml = s:base_dir . 'lsp.toml'
    let s:dein_ft_toml = s:base_dir . 'deinft.toml'

    call dein#load_toml(s:dein_toml, {'lazy': 0})
    call dein#load_toml(s:dein_lazy_toml, {'lazy': 1})
    call dein#load_toml(s:dein_status_toml, {'lazy': 1})
    call dein#load_toml(s:dein_cmp_toml, {'lazy': 1})
    call dein#load_toml(s:dein_lsp_toml, {'lazy': 1})
    call dein#load_toml(s:dein_ft_toml)

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable

let g:nightflyItalics = v:false
colorscheme nightfly
