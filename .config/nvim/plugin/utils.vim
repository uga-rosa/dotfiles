" Show highlight group
command! -nargs=0 SynGroup call s:syn_group()
function! s:syn_group() abort
  let id = synID(line('.'), col('.'), 1)
  echo synIDattr(id, 'name') '->' synIDattr(synIDtrans(id), 'name')
endfunction
