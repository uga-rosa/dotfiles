local api = vim.api

_G.utils = {}

if not vim.keymap then
    vim.keymap = {}
    vim.keymap._function = {}
    function vim.keymap.set(mode, lhs, rhs, opt)
        if type(rhs) == "function" then
            local idx = #vim.keymap._function + 1
            vim.keymap._function[idx] = rhs
            rhs = ("<cmd>lua vim.keymap._function[%d]()<cr>"):format(idx)
        end
        mode = type(mode) == "table" and mode or {mode}
        for _, m in ipairs(mode) do
            api.nvim_set_keymap(m, lhs, rhs, opt)
        end
    end
end

---API for keymap
---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opt list
function utils.map(mode, lhs, rhs, opt)
    opt = type(opt) == "table" and opt or { opt }
    for i, o in ipairs(opt) do
        opt[o] = true
        opt[i] = nil
    end
    vim.keymap.set(mode, lhs, rhs, opt)
end

function utils.feedkey(key, mode)
    api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, true, true), mode or "n", true)
end

---Transforms ctx into a human readable representation.
---@vararg any
function _G.dump(...)
    for _, ctx in ipairs({ ... }) do
        print(vim.inspect(ctx))
    end
end
