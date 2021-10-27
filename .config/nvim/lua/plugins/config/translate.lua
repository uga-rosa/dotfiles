vim.cmd([[
command! -range TransJa2EnFloat lua require("translate_shell").translate(<line1>, <line2>, "ja", "en", "f")
command! -range TransJa2EnReplace lua require("translate_shell").translate(<line1>, <line2>, "ja", "en", "r")
command! -range TransEn2JaFloat lua require("translate_shell").translate(<line1>, <line2>, "en", "ja", "f")
command! -range TransEn2JaReplace lua require("translate_shell").translate(<line1>, <line2>, "en", "ja", "r")

augroup _translate
    autocmd!
    autocmd CursorMoved * lua require("translate_shell").close()
augroup END
]])
