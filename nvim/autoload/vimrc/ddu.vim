function vimrc#ddu#move(dir, ...) abort
  let lnum = line('.')
  let ignore_dummy = a:0 > 0
  if ignore_dummy
    while getline(lnum + a:dir) =~# '^>>.*<<$'
      let lnum += a:dir
    endwhile
  endif
  let lnum += a:dir
  if 1 <= lnum && lnum <= line('$')
    return lnum . 'gg'
  endif
  return ''
endfunction
