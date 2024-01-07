function rc#toml#parse(raw) abort
  if denops#plugin#wait('rc')
    return {}
  endif
  return denops#request('rc', 'toml_parse', [a:raw])
endfunction

function rc#toml#stringify(obj) abort
  if denops#plugin#wait('rc')
    return ''
  endif
  return denops#request('rc', 'toml_stringfy', [a:obj])
endfunction
