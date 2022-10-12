function! s:execute_map(key, mode) abort
  if a:mode == 'i'
    startinsert
  endif
  let key = nvim_replace_termcodes(a:key, v:true, v:true, v:true)
  call nvim_feedkeys(key, 'n', v:false)
endfunction

function! s:get_keymap(mode) abort
  return map(nvim_get_keymap(a:mode), { _, keymap -> keymap.lhs })
endfunction

function! s:get_nmap(ArgLead, CmdLine, CursorPos) abort
  return s:get_keymap('n')
endfunction

function! s:get_imap(ArgLead, CmdLine, CursorPos) abort
  return s:get_keymap('i')
endfunction

command! -nargs=1 -complete=customlist,s:get_nmap ExecuteNMap call s:execute_map(<q-args>, 'n')
command! -nargs=1 -complete=customlist,s:get_imap ExecuteIMap call s:execute_map(<q-args>, 'i')
