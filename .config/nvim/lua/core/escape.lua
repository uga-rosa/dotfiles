local M = {}

local feedkey = myutils.feedkey

local flag = false

local function time_count()
    flag = true
    vim.defer_fn(function()
        flag = false
    end, vim.o.timeoutlen)
end

function M.leave()
    flag = false
end

function M.escape()
    local insert_char = vim.v.char
    if insert_char == "j" then
        if flag then
            vim.v.char = ""
            feedkey("<bs><esc>", "n")
        else
            time_count()
        end
    elseif insert_char == "k" then
        if flag then
            vim.v.char = ""
            feedkey("<bs><esc>", "n")
        end
    end
end

return M
