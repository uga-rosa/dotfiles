function! s:Sum() range
  echo v:lua.myutils.sum(a:firstline, a:lastline)
endfunction

function! s:Mean() range
  echo v:lua.myutils.mean(a:firstline, a:lastline)
endfunction

command! -range Sum <line1>,<line2>call s:Sum()
command! -range Mean <line1>,<line2>call s:Mean()
