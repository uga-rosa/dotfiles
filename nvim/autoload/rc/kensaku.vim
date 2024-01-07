function! rc#kensaku#start(dir) abort
  let g:searchx_kensaku = v:true
  au User SearchxLeave ++once let g:searchx_kensaku = v:false
  call searchx#start(#{
        \ dir: a:dir,
        \ convert: {input -> kensaku#query(input)}
        \})
endfunction
