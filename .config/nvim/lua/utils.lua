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
---@param rhs string|string[]|T|T[]
---@param opts? string|string[]
---@overload fun(modes: string, lhs: string, rhs: string)
---opts.nowait: This make a shortest match.
---opts.silent: No echo.
---opts.expr: Deprecated. Use feedkeys().
---opts.buffer: current buffer only
---opts.cmd: command (format to <cmd>%s<cr>)
vim_api.map = function(modes, lhs, rhs, opts)
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

    rhs = type(rhs) == "table" and rhs or { rhs }
    local _rhs = {}

    for i = 1, #rhs do
        if type(rhs[i]) == "function" then
            opts.cmd = true
            _rhs[i] = func2str(function()
                rhs[i](fallback(lhs))
            end)
        else
            _rhs[i] = rhs[i]
        end
        if opts.cmd then
            _rhs[i] = "<cmd>" .. _rhs[i] .. "<cr>"
        end
    end
    _rhs = table.concat(_rhs, "")

    if opts.cmd then
        opts.noremap = true
        opts.cmd = nil
    end

    modes = type(modes) == "string" and { modes } or modes
    for _, mode in ipairs(modes) do
        if buffer then
            api.nvim_buf_set_keymap(0, mode, lhs, _rhs, opts)
        else
            api.nvim_set_keymap(mode, lhs, _rhs, opts)
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
vim_api.map_conv = function(modes, a, b, opts)
    vim_api.map(modes, a, b, opts)
    vim_api.map(modes, b, a, opts)
end

---API for autocmd. Supports for a lua funcion.
---@param au string[]
---The last element of au can be a function.
vim_api.autocmd = function(au)
    if type(au[#au]) == "function" then
        au[#au] = func2str(au[#au])
    end
    cmd(table.concat(vim.tbl_flatten({ "au", au }), " "))
end

---API for augroup. Supports for a lua function.
---@param augroups table<string,string[]>
---augroups' key: group named
---augroups' value: an argument of myutils.autocmd
vim_api.augroup = function(augroups)
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
vim_api.command = function(command)
    if type(command) == "table" then
        if type(command[#command]) == "function" then
            command[#command] = func2str(command[#command])
        end
        command = table.concat(command, " ")
    end
    cmd("com! " .. command)
end

---Execute a string as a function.
---@param inStr string
---@return any ReturnFunction
vim_api.eval = function(inStr)
    return assert(load(inStr))()
end

---@class Array
_G.array = {}

---Returns a instance of class Array
---@param t table
---@return Array
function array.new(t)
    return setmetatable(t, { __index = array })
end

---Returns a new array with func applied to each elements.
---If no_return is true, returns nothing.
---@param self Array
---@param func function
---@param no_return boolean
---@return Array
function array:map(func, no_return)
    if no_return then
        for i = 1, #self do
            func(self[i])
        end
    else
        local res = {}
        for i = 1, #self do
            res[i] = func(self[i])
        end
        return array.new(res)
    end
end

---Returns a new array with all the elements of self that fulfilled func
---@param self Array
---@param func fun(a: any): boolean
---@return Array
function array:filter(func)
    local res, c = {}, 0
    for i = 1, #self do
        if func(self[i]) then
            c = c + 1
            res[c] = self[i]
        end
    end
    return array.new(res)
end

---Returns true if e is contained in self, false otherwise.
---@param self Array
---@param e any
---@return boolean
function array:contain(e)
    for i = 1, #self do
        if self[i] == e then
            return true
        end
    end
    return false
end

---Transforms ctx into a human readable representation.
---@param ctx any
_G.dump = function(ctx)
    print(vim.inspect(ctx))
end
