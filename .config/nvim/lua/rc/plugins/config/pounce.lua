require("pounce").setup({
    accept_keys = "JFKDLSAHGNUVRBYTMICEOXWPQZ",
    accept_best_key = "<enter>",
    multi_window = true,
    debug = false,
})

vim.cmd([[
highlight PounceMatch      cterm=underline,bold ctermfg=gray ctermbg=214 gui=underline,bold guifg=#555555 guibg=#FFAF60
highlight PounceGap        cterm=underline,bold ctermfg=gray ctermbg=209 gui=underline,bold guifg=#555555 guibg=#E27878
highlight PounceAccept     cterm=underline,bold ctermfg=214 ctermbg=gray gui=underline,bold guifg=#FFAF60 guibg=#555555
highlight PounceAcceptBest cterm=underline,bold ctermfg=196 ctermbg=gray gui=underline,bold guifg=#EE2513 guibg=#555555
highlight PounceUnmatched                       ctermfg=248                                 guifg=#777777
]])

Keymap.set("n", "ss", "<Cmd>Pounce<CR>")
