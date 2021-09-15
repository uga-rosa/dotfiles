syn match snippetStart /^snippet/ nextgroup=snippetTriger skipwhite
syn match snippetTriger /.*$/ contained
syn match snippetEnd /^endsnippet/
syn match TrailingSpaces / \+$/

highlight link snippetStart Function
highlight link snippetEnd Function
highlight link snippetTriger Identifier
highlight TrailingSpaces guibg=#4b6479

let b:current_syntax = "snip"
