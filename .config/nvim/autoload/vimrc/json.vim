function! vimrc#json#read(path) abort
  return json_decode(join(readfile(expand(a:path))))
endfunction

function! vimrc#json#write(ctx, path) abort
  call writefile([json_encode(a:ctx)], a:path)
endfunction
