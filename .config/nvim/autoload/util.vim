function! util#keymap(...) abort
    if a:0 < 3
        return
    endif

    let l:modes = split(a:1, '\zs')

    if match(a:2, '^\%(<\l*>\)\+$') > -1
        let l:opts = a:2
        let l:lhs = a:3
        let l:rhs = join(copy(a:000)[3:], ' ')
    else
        let l:opts = ''
        let l:lhs = a:2
        let l:rhs = join(copy(a:000)[2:], ' ')
    endif

    if match(l:opts, '<remap>') > -1
        let l:opts = substitute(l:opts, '<remap>', '', '')
        let l:command = 'map'
    elseif match(l:rhs, '\c^<plug>') > -1
        let l:command = 'map'
    else
        let l:command = 'noremap'
    endif

    for mode in l:modes
        execute mode . l:command . l:opts . ' ' . l:lhs . ' ' . l:rhs
    endfor
endfunction
