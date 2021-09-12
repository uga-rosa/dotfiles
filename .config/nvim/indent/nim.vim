"Copyright (c) 2012-2016, Zahary Karadjov and Contributors.
"https://github.com/zah/nim.vim/blob/master/LICENSE

if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetNimIndent(v:lnum)
setlocal indentkeys=!^F,o,O,<:>,0),0],0},=elif

if exists('*GetNimIndent')
  finish
endif

function! s:FindStartLine(fromln, pattern)
  let lnum = a:fromln
  let safechoice = indent(lnum)
  while getline(lnum) !~ a:pattern
    if indent(lnum) == 0 || lnum == 1
      return safechoice
    endif
    let lnum = lnum - 1
  endwhile
  return indent(lnum)
endfunction

function! GetNimIndent(lnum)
  let plnum = prevnonblank(a:lnum - 1)

  if plnum == 0
    return 0
  endif

  if has('syntax_items') && synIDattr(synID(a:lnum, 1, 1), 'name') =~# 'String$'
    return -1
  endif

  let pline = getline(plnum)
  let cline = getline(a:lnum)
  let pline_len = strlen(pline)
  let plindent = indent(plnum)
  let clindent = indent(a:lnum)

  if has('syntax_items')
    if synIDattr(synID(plnum, pline_len, 1), 'name') =~# 'Comment$'
      let min = 1
      let max = pline_len
      while min < max
        let col = (min + max) / 2
        if synIDattr(synID(plnum, col, 1), 'name') =~# 'Comment$'
          let max = col
        else
          let min = col + 1
        endif
      endwhile
      let pline = strpart(pline, 0, min - 1)
    endif
  else
    let col = 0
    while col < pline_len
      if pline[col] == '#'
        let pline = strpart(pline, 0, col)
        break
      endif
      let col = col + 1
    endwhile
  endif

  if cline =~# '^\s*\(if\|when\|for\|while\|case\|of\|try\)\>'
    return -1
  endif

  if cline =~# '^\s*\(except\|finally\)\>'
    let lnum = a:lnum - 1
    while lnum >= 1
      if getline(lnum) =~# '^\s*\(try\|except\)\>'
        let ind = indent(lnum)
        if ind >= clindent
          return -1
        endif
        return ind
      endif
      let lnum = lnum - 1
    endwhile
    return -1
  endif

  if cline =~# '^\s*\(elif\|else\)\>'
    return s:FindStartLine(a:lnum, '^\s*\(if\|when\|elif\|of\)')
  endif

  if pline =~# ':\s*$'
    return s:FindStartLine(plnum, '^\s*\(if\|when\|else\|elif\|for\|while\|case\|of\|try\|except\|finally\)\>') + &sw
  endif

  if pline =~# '=\s*$'
    return s:FindStartLine(plnum, '^\s*\(proc\|template\|macro\|iterator\)\>') + &sw
  endif

  if pline =~# '^\s*\(if\|when\|proc\|iterator\|macro\|template\|for\|while\)[^:]*$'
    return plindent + &sw
  endif

  if pline =~# '\(type\|import\|const\|var\|let\)\s*$'
    \ || pline =~# '=\s*\(object\|enum\|tuple\|concept\)'
    return plindent + &sw
  endif

  if pline =~# '^\s*\(break\|continue\|raise\|return\)\>'
    if indent(a:lnum) > plindent - &sw
      return plindent - &sw
    endif
    return -1
  endif

  return -1

endfunction
