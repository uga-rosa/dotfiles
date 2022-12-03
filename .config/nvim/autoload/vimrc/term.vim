let s:termname = 'nvim_terminal'

function! s:open() abort
  botright 15sp
  if bufexists(s:termname)
    exec 'buffer ' . s:termname
  else
    terminal
    exe 'file ' . s:termname
    setl nobuflisted
  endif
  startinsert
endfunction

function! s:close(winid) abort
  call win_execute(a:winid, 'hide')
endfunction

function! ugaterm#toggle() abort
  let winid = bufwinid(s:termname)
  if winid == -1
    call s:open()
  else
    call s:close(winid)
  endif
endfunction
