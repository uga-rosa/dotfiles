tnoremap <Esc> <C-\><C-n>
Keymap nt <C-t> <Cmd>call vimrc#term#toggle()<CR>

nnoremap <space>gg <Cmd>call vimrc#lazygit#open()<CR>

command! -nargs=+ KeepCursor call vimrc#keep_cursor(<q-args>)
