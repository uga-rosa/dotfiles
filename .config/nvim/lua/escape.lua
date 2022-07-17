local M = {}

local function feedkey(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode or "n", true)
end

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
            feedkey("<BS><Esc>", "n")
        else
            time_count()
        end
    elseif insert_char == "k" then
        if flag then
            vim.v.char = ""
            feedkey("<BS><Esc>", "n")
        end
    end
end

return M
