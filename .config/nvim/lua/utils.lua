local luv = vim.loop

---Transforms ctx into a human readable representation.
---@vararg any
function _G.dump(...)
    for _, obj in ipairs({ ... }) do
        print(vim.inspect(obj, { depth = 3 }))
    end
end

_G.Keymap = {}
_G.Path = {}

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
    local mode = modes == "" and { "" } or vim.split(modes, "")

    local opts = {}
    optstring = optstring or ""
    for s in vim.gsplit(optstring, "") do
        local opt = optsShorts[s]
        opts[opt] = true
    end
    if bufnr then
        opts.buffer = bufnr
    end

    vim.keymap.set(mode, lhs, rhs, opts)
end

---@param mode string | string[]
---@param lhs string
---@param rhs string
function Keymap.abbr(mode, lhs, rhs)
    mode = type(mode) == "string" and { mode } or mode
    for _, m in ipairs(mode) do
        vim.cmd(m .. "ab " .. lhs .. " " .. rhs)
    end
end

---Check the file exists.
---@param filepath string
---@return boolean
function Path.exists(filepath)
    ---@diagnostic disable-next-line
    filepath = vim.fn.expand(filepath)
    local ok = luv.fs_open(filepath, "r", 438)
    return ok and true or false
end
