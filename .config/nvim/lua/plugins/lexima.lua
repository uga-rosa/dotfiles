local rules = {
  { char = "$", input_after = "$", filetype = "markdown" },
  { char = "$", at = [[\%#\$]], leave = 1, filetype = "markdown" },
  { char = "<bs>", at = [[\$\%#\$]], delete = 1, filetype = "markdown" },
  { char = "-", at = [[<!-\%#]], input_after = [[-->]], filetype = "markdown" },
}

for _, v in ipairs(rules) do
  vim.fn["lexima#add_rule"](v)
end
