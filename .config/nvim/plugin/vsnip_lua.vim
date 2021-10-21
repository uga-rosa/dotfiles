function! s:LUA(context) abort
  let l:script = join(map(copy(a:context.node.children), 'v:val.text()'), '')
  try
    return luaeval(l:script)
  catch /.*/
  endtry
  return v:null
endfunction
call vsnip#variable#register('LUA', function('s:LUA'))
