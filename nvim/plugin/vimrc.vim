nnoremap <space>gg <Cmd>call vimrc#lazygit#open()<CR>

command! CacheDenopsPlugins :lua require("rc.utils.deno").cache_denops_plugins()
