vim.cmd([[
let g:gindent = {}
let g:gindent.enabled = { -> index(['vim', 'lua', 'python'], &filetype) != -1 }
]])
