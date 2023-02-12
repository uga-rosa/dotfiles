;; extends
((pair
  (bare_key) @_key
  (string) @none)
 (#vim-match? @_key "^%(hook|lua)_\w*")
 (#vim-match? @none "^('''|\"\"\")")
 (#offset! @none 0 3 0 -3))
((pair
  (bare_key) @_key
  (string) @none)
 (#vim-match? @_key "^%(hook|lua)_\w*")
 (#vim-match? @none "^('[^']|\"[^\"])")
 (#offset! @none 0 1 0 -1))
((table
  (bare_key) @_key
  (pair
   (string) @none))
 (#vim-match? @_key "^%(plugins\.)?ftplugin$")
 (#vim-match? @none "^('''|\"\"\")")
 (#offset! @none 0 3 0 -3))
((table
  (bare_key) @_key
  (pair
   (string) @none))
 (#vim-match? @_key "^%(plugins\.)?ftplugin$")
 (#vim-match? @none "^('[^']|\"[^\"])")
 (#offset! @none 0 1 0 -1))
