nnoremap <space>gg <Cmd>call vimrc#lazygit#open()<CR>

command! -nargs=+ KeepCursor call vimrc#keep_cursor(<q-args>)
