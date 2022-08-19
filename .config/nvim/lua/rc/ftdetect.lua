local M = {
    {
        pattern = "*.ahk",
        filetype = "autohotkey",
    },
    {
        pattern = "*.inp",
        filetype = "packmol",
    },
}

local group_name = "ftdetect"
vim.api.nvim_create_augroup(group_name, {})
for _, ftdetect in ipairs(M) do
    local pattern = ftdetect.pattern
    local filetype = ftdetect.filetype
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = pattern,
        command = "setf " .. filetype,
    })
end
