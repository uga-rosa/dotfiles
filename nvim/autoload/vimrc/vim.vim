function vimrc#vim#gd(...) abort
  const word = a:0 ? a:1 : expand('<cword>')
  if word !~# '\v%(\w+#)+'
    normal! gd
    return
  endif
  const fname = word
        \ ->matchstr('\v%(\w+#)+')
        \ ->substitute('#', '/', 'g')
        \ ->substitute('/$', '', '')
        \ ->printf('autoload/%s.vim')
  const files = globpath(&rtp, fname, v:false, v:true)
  echom fname files
  if files->len() != 1
    return
  endif
  exe 'edit' files[0]
  call search(word->printf('\Vfunction!\?\s\+\zs\<%s\>'))
  let @/ = word->printf('\V\<%s\>')
endfunction
