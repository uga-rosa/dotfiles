_G.utils = {}

function utils.feedkey(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode or "n", true)
end

---Transforms ctx into a human readable representation.
---@vararg any
function _G.dump(...)
    for _, ctx in ipairs({ ... }) do
        print(vim.inspect(ctx))
    end
end
