local lexima = {}

---@param rule table
function lexima.add_rule(rule)
    vim.fn["lexima#add_rule"](rule)
end

vim.g.lexima_ctrlh_as_backspace = 1

lexima.add_rule({
    char = "[",
    at = "[=\\%#",
    input = "[",
    input_after = "]=",
    mode = "i",
    filetype = "lua",
})

lexima.add_rule({
    char = "(",
    at = "\\\\%\\%#",
    input = "(",
    input_after = "\\)",
    mode = "i",
    filetype = "lua",
})
