function! vimrc#fold_toml(lnum) abort
  let line = getline(a:lnum)
  return line ==# '' || line[0:3] ==# '    '
endfunction
