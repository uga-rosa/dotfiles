let s:termname = 'nvim_terminal'

function! s:open(buf) abort
  botright 15sp
  if a:buf > 0
    exec 'buffer ' . s:termname
    startinsert
  else
    terminal
    startinsert
    exe 'file ' . s:termname
    setl nobuflisted
  endif
endfunction

function! s:close(pane) abort
  exe a:pane . 'wincmd c'
endfunction

function! ugaterm#toggle() abort
  let pane = bufwinnr(s:termname)
  let buf = bufexists(s:termname)
  if pane > 0
    call s:close(pane)
  else
    call s:open(buf)
  endif
endfunction
