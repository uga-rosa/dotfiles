local api = vim.api
local cmd = vim.cmd

_G.vim_api = {}

vim_api.func = setmetatable({}, {
    __call = function(self, num)
        return self[num]()
    end,
})

---Return a string for vim from a lua function. Functions are stored in _G.myluafunc.
---@param func function
---@return string VimFunctionString
local function func2str(func)
    local idx = #vim_api.func + 1
    vim_api.func[idx] = func
    return "lua vim_api.func(" .. idx .. ")"
end

function vim_api.feedkey(key, mode)
    mode = mode or "n"
    api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local function fallback(key)
    return function()
        vim_api.feedkey(key)
    end
end

---API for key mapping.
---T : fun(fallback: function)
---@generic T fun(fallback: function)
---@param modes string|string[]
---@param lhs string
---@param rhss string|string[]|T|T[]
---@param opts? string|string[]
---@overload fun(modes: string, lhs: string, rhs: string)
---opts.nowait: This make a shortest match.
---opts.silent: No echo.
---opts.expr: Deprecated. Use feedkeys().
---opts.buffer: current buffer only
---opts.cmd: command (format to <cmd>%s<cr>)
function vim_api.map(modes, lhs, rhss, opts)
    opts = opts or {}
    opts = type(opts) == "table" and opts or { opts }
    for key, opt in ipairs(opts) do
        opts[opt] = true
        opts[key] = nil
    end

    local buffer = false
    if opts.buffer then
        buffer = true
        opts.buffer = nil
    end

    rhss = type(rhss) == "table" and rhss or { rhss }
    local rhs = {}

    for i, r in ipairs(rhss) do
        if type(r) == "function" then
            opts.cmd = true
            rhs[i] = func2str(function()
                r(fallback(lhs))
            end)
        else
            rhs[i] = r
        end
        if opts.cmd then
            rhs[i] = "<cmd>" .. rhs[i] .. "<cr>"
        end
    end
    rhs = table.concat(rhs, "")

    if opts.cmd then
        opts.noremap = true
        opts.cmd = nil
    end

    modes = type(modes) == "string" and { modes } or modes
    for _, mode in ipairs(modes) do
        if buffer then
            api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
        else
            api.nvim_set_keymap(mode, lhs, rhs, opts)
        end
    end
end

---Exchange of two key
---@param modes string|string[]
---@param a string
---@param b string
---@param opts string|string[]
---@overload fun(modes: string, a: string, b: string)
---opts.nowait: This make a shortest match.
---opts.silent: No echo.
---opts.expr: Deprecated. Use feedkeys().
---opts.buffer: current buffer only
---opts.cmd: command (format to <cmd>%s<cr>)
function vim_api.map_conv(modes, a, b, opts)
    vim_api.map(modes, a, b, opts)
    vim_api.map(modes, b, a, opts)
end

---API for autocmd. Supports for a lua funcion.
---@param au string[]
---The last element of au can be a function.
function vim_api.autocmd(au)
    if type(au[#au]) == "function" then
        au[#au] = func2str(au[#au])
    end
    cmd(table.concat(vim.tbl_flatten({ "au", au }), " "))
end

---API for augroup. Supports for a lua function.
---@param augroups table<string,string[]>
---augroups' key: group named
---augroups' value: an argument of myutils.autocmd
function vim_api.augroup(augroups)
    for group, aus in pairs(augroups) do
        cmd("augroup " .. group)
        cmd("au!")
        if type(aus[1]) == "table" then
            for i = 1, #aus do
                vim_api.autocmd(aus[i])
            end
        else
            vim_api.autocmd(aus)
        end
        cmd("augroup END")
    end
end

---API for command. Supports for a lua function
---@param command string|table
function vim_api.command(command)
    if type(command) == "table" then
        if type(command[#command]) == "function" then
            command[#command] = func2str(command[#command])
        end
        command = table.concat(command, " ")
    end
    cmd("com! " .. command)
end

local function tbl_copy(t)
    if type(t) ~= "table" then
        return t
    end
    local ret = {}
    for key, value in pairs(t) do
        if type(value) == "table" then
            ret[key] = tbl_copy(value)
        else
            ret[key] = value
        end
    end
    return ret
end

---Transforms ctx into a human readable representation.
---@vararg any
_G.dump = function(...)
    for _, ctx in ipairs({ ... }) do
        print(vim.inspect(ctx))
    end
end

---Ignore metatable
---@vararg any
function _G._dump(...)
    for _, ctx in ipairs({ ... }) do
        print(vim.inspect(tbl_copy(ctx)))
    end
end
