local M = {}

local uv = vim.loop

M.paste = function()
    local name = os.date("%Y-%m-%d-%H-%M-%S") .. ".png"
    local dir = vim.fn.expand("%:p:h") .. "/image"
    vim.fn.mkdir(dir, "p")

    uv.spawn("pasteimage.sh", {
        args = { name },
        cwd = dir,
    }, function(code, _)
        if code == 0 then
            print("Paste success.")
        else
            print("Paste failure.")
        end
    end)

    vim.api.nvim_set_current_line(("![](image/%s)"):format(name))
end

M.setup = function()
    vim.cmd([[command! PasteImage lua require('myplug.pasteimage').paste()]])
end

return M
