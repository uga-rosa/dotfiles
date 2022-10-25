_G.dump = vim.pretty_print

_G.Keymap = {}

local optsShorts = {
    b = "buffer",
    n = "nowait",
    s = "silent",
    c = "script",
    e = "expr",
    u = "unique",
    r = "remap",
}

---utility of vim.keymap.set
---@param modes string #It is splited character by character into a list.
---@param lhs string #Same as vim.keymap.set
---@param rhs string | function #Same as vim.keymap.set
---@param optstring? string #Difference from vim.keymap.set.
---You can specify options in string form using the shorthand.
---b: buffer
---n: nowait
---s: silent
---c: script
---e: expr
---u: unique
---r: remap
---
---Example:
---Keymap.set("in", "hoge", "huga", "bsr")
---is same as
---vim.keymap.set({ "i", "n" }, "hoge", "huga", { buffer = true, silent = true, remap = true })
---@param bufnr? integer
function Keymap.set(modes, lhs, rhs, optstring, bufnr)
    modes = modes == "" and "nicxo" or modes
    local mode = vim.split(modes, "")

    local opts = {}
    optstring = optstring or ""
    for s in vim.gsplit(optstring, "", true) do
        local opt = optsShorts[s]
        opts[opt] = true
    end
    if bufnr then
        opts.buffer = bufnr
    end

    vim.keymap.set(mode, lhs, rhs, opts)
end

---@type table<string, fun(...: unknown): boolean>
vim.bool_fn = setmetatable({}, {
    __index = function(_, key)
        return function(...)
            local v = vim.fn[key](...)
            if not v or v == 0 or v == "" then
                return false
            elseif type(v) == "table" and next(v) == nil then
                return false
            end
            return true
        end
    end,
})
