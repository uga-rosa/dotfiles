function s:in_range(list, idx) abort
  return a:idx >= 0 && a:idx < a:list->len()
endfunction

function rc#move#buffer(delta) abort
  if a:delta == 0
    throw 'Invalid delta: 0'
  endif

  let jumplist = getjumplist()[0]
  let cur = getjumplist()[1]
  let dir = a:delta > 0 ? 1 : -1

  let old_bufnr = jumplist->get(cur, {})->get('bufnr', bufnr())

  let remain = abs(a:delta)
  let count = 0
  while remain
    let cur += dir
    if !s:in_range(jumplist, cur)
      return
    endif
    if jumplist[cur].bufnr != old_bufnr
      let remain -= 1
      let old_bufnr = jumplist[cur].bufnr
    endif
    let count += 1
  endwhile

  let cmd = a:delta > 0 ? "\<C-i>" : "\<C-o>"
  try
    exe 'normal! ' .. count .. cmd
  catch /E19/
    " ignore
  endtry
endfunction
