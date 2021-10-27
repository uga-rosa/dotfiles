local map = myutils.map
local f = vim.fn
local c = vim.cmd

map("t", "<esc>", "<C-\\><C-n>", "noremap")

map({ "n", "t" }, "<C-t>", function()
    local termname = "nvim_terminal"
    local pane = f.bufwinnr(termname)
    local buf = f.bufexists(termname)
    if pane > 0 then
        c(pane .. "wincmd c")
    elseif buf > 0 then
        c("botright 15split")
        c("buffer " .. termname)
        c("startinsert")
    else
        c("botright 15split")
        c("terminal")
        c("startinsert")
        c("f " .. termname)
        vim.opt_local.buflisted = false
    end
end)
