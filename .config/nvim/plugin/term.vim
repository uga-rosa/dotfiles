let s:termname = "nvim_terminal"

function! TermToggle() abort
    let l:pane = bufwinnr(s:termname)
    let l:buf = bufexists(s:termname)
    if pane > 0
        execute pane . "wincmd c"
    elseif buf > 0
        botright 15sp
        execute "buffer " . s:termname
        startinsert
    else
        botright 15sp
        terminal
        startinsert
        execute "f " . s:termname
        setlocal nobuflisted
    endif
endfunction

nnoremap <C-t> <cmd>call TermToggle()<cr>
tnoremap <C-t> <cmd>call TermToggle()<cr>
tnoremap <esc> <C-\><C-n>
