function! utils#set_indent(...) abort
	let tab_size = a:1
	let is_hard_tab = a:0 > 1 ? a:2 : 0
	let &l:expandtab = !is_hard_tab
	let &l:tabstop = tab_size
	let &l:softtabstop = tab_size
	let &l:shiftwidth = tab_size
endfunction
