local add_rule = vim.fn["lexima#add_rule"]

add_rule({ char = "$", input_after = "$", filetype = "markdown" })
add_rule({ char = "$", at = "\\%#\\$", leave = 1, filetype = "markdown" })

local function lexima_alter_command(orig, alt)
    local input_space = "<C-w>" .. alt .. "<Space>"
    local input_cr = "<C-w>" .. alt .. "<CR>"
    local rule = {
        mode = ":",
        at = [[^\('<,'>\)\?]] .. orig .. [[\%#$]],
    }
    add_rule(vim.tbl_extend("error", rule, { char = "<Space>", input = input_space }))
    add_rule(vim.tbl_extend("error", rule, { char = "<CR>", input = input_cr }))
end

lexima_alter_command("r\\%[un]", "QuickRun")
lexima_alter_command("ps", "PackerSync")
