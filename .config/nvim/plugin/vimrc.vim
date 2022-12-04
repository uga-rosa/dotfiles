tnoremap <Esc> <C-\><C-n>

nnoremap <C-t> <Cmd>call vimrc#term#toggle()<CR>
tnoremap <C-t> <Cmd>call <SID>toggle()<CR>

function! s:toggle() abort
  if &ft !=# 'fzf'
    call vimrc#term#toggle()
  else
    call feedkeys("\<C-t>", 'n')
  endif
endfunction
