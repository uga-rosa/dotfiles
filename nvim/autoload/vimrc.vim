function! vimrc#set_indent(...) abort
	let tab_size = a:0 > 0 ? a:1 : 4
	let is_hard_tab = a:0 > 1 ? a:2 : 0
	let &l:expandtab = !is_hard_tab
	let &l:tabstop = tab_size
	let &l:softtabstop = tab_size
	let &l:shiftwidth = tab_size
endfunction

function! vimrc#keymap(remap, modes, ...) abort
  let arg = join(a:000, ' ')
  " Recently, even if arg contains '<Plug>', noremap works fine.
  let cmd = a:remap ? 'map' : 'noremap'
  for mode in split(a:modes, '.\zs')
    if mode =~# '[nvsxoilct]'
      execute mode . cmd arg
    else
      echohl Error
      echomsg printf('Invalid mode is detected: %s (%s)', mode, arg)
      echohl None
    endif
  endfor
endfunction

" Show highlight group
function! vimrc#syn_group() abort
  let id = synID(line('.'), col('.'), 1)
  echo synIDattr(id, 'name') '->' synIDattr(synIDtrans(id), 'name')
endfunction
