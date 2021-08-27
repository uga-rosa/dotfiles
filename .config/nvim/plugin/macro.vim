command! -range MacroRun call s:command_macro_run(<range>)

function! s:command_macro_run(range) abort
  if getreg('q') == ''
    return
  endif

  let l:pos = getpos('.')

  let l:start = line('.')
  let l:end = l:start
  if a:range == 2
    let l:start = getpos("'<")[1]
    let l:end = getpos("'>")[1]
  endif

  let l:changenr = changenr()
  for l:i in range(l:start, l:end)
    execute printf('normal! %sG0@q', l:i)
  endfor
  let l:lines = getbufline('%', l:start, l:end)
  execute printf('%sundo', l:changenr)
  call setbufline('%', l:start, l:lines)
  call setpos('.', l:pos)
endfunction
