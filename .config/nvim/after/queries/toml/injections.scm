((pair
  (bare_key) @_key
  (string) @vim)
 (#vim-match? @_key "^hook_(add|source|post_source)")
 (#offset! @vim 0 3 0 -3))
((table
  (bare_key) @_key
  (pair
   (string) @vim))
 (#eq? @_key "ftplugin")
 (#offset! @vim 0 3 0 -3))
((table
  (dotted_key) @_key
  (pair
   (string) @vim))
 (#eq? @_key "plugins.ftplugin")
 (#offset! @vim 0 3 0 -3))
