let s:termname = 'nvim_terminal'

function! term#open(buf) abort
    if a:buf > 0
        botright 15sp
        execute 'buffer ' . s:termname
        startinsert
    else
        botright 15sp
        terminal
        startinsert
        execute 'f ' . s:termname
        setlocal nobuflisted
    endif
endfunction

function! term#close(pane) abort
    execute a:pane . 'wincmd c'
endfunction

function! term#mapping() abort
    tnoremap <esc> <C-\><C-n>
endfunction

function term#toggle() abort
    let l:pane = bufwinnr(s:termname)
    let l:buf = bufexists(s:termname)
    if pane > 0
        call term#close(l:pane)
    else
        call term#open(l:buf)
        call term#mapping()
    endif
endfunction
