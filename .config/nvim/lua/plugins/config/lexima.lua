local add_rule = vim.fn["lexima#add_rule"]

add_rule({ char = "$", input_after = "$", filetype = "markdown" })
add_rule({ char = "$", at = "\\%#\\$", leave = 1, filetype = "markdown" })
