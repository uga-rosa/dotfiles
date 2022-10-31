" operator-user - Define your own operator easily
" Version: 0.1.0
" Copyright (C) 2009-2015 Kana Natsuno <http://whileimautomaton.net/>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

function! operator#user#define(name, function_name, ...)
  return call('operator#user#_define',
  \           ['<Plug>(operator-' . a:name . ')', a:function_name] + a:000)
endfunction

function! operator#user#define_ex_command(name, ex_command)
  return operator#user#define(
  \        a:name,
  \        'operator#user#_do_ex_command',
  \        'call operator#user#_set_ex_command(' . string(a:ex_command) . ')'
  \      )
endfunction

function! operator#user#register()
  return s:register
endfunction

function! operator#user#visual_command_from_wise_name(wise_name)
  if a:wise_name ==# 'char'
    return 'v'
  elseif a:wise_name ==# 'line'
    return 'V'
  elseif a:wise_name ==# 'block'
    return "\<C-v>"
  else
    echoerr 'operator-user:E1: Invalid wise name:' string(a:wise_name)
    return 'v'  " fallback
  endif
endfunction

function! operator#user#_define(operator_keyseq, function_name, ...)
  if 0 < a:0
    let additional_settings = '\|' . join(a:000)
  else
    let additional_settings = ''
  endif

  execute printf(('nnoremap <script> <silent> %s ' .
  \               ':<C-u>call operator#user#_set_up(%s)%s<Return>' .
  \               '<SID>(count)' .
  \               '<SID>(register)' .
  \               'g@'),
  \              a:operator_keyseq,
  \              string(a:function_name),
  \              additional_settings)
  execute printf(('vnoremap <script> <silent> %s ' .
  \               ':<C-u>call operator#user#_set_up(%s)%s<Return>' .
  \               'gv' .
  \               '<SID>(register)' .
  \               'g@'),
  \              a:operator_keyseq,
  \              string(a:function_name),
  \              additional_settings)
  execute printf('onoremap %s  g@', a:operator_keyseq)
endfunction

function! operator#user#_set_up(operator_function_name)
  let &operatorfunc = a:operator_function_name
  let s:count = v:count
  let s:register = v:register
endfunction

function! operator#user#_do_ex_command(motion_wiseness)
  execute "'[,']" s:ex_command
endfunction

function! operator#user#_set_ex_command(ex_command)
  let s:ex_command = a:ex_command
endfunction

function! s:count()
  return s:count ? s:count : ''
endfunction

nnoremap <expr> <SID>(count)  <SID>count()

function! s:register()
  return s:register == '' ? '' : '"' . s:register
endfunction

nnoremap <expr> <SID>(register)  <SID>register()
vnoremap <expr> <SID>(register)  <SID>register()

function! operator#user#_sid_prefix()
  return s:SID_PREFIX()
endfunction

function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '\%(^\|\.\.\)\zs<SNR>\d\+_\zeSID_PREFIX$')
endfunction
