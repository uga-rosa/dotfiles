function! rc#lazygit#open() abort
  tabnew
  terminal lazygit
  startinsert
  setl nonumber

  tnoremap <buffer> q <Cmd>bdelete!<CR>
endfunction
