local cmd = vim.cmd
local api = vim.api

_G.vim_api = {}
_G.utils = {}

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

---API for keymap
---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opt list
function vim_api.map(mode, lhs, rhs, opt)
    opt = type(opt) == "table" and opt or { opt }
    for i, o in ipairs(opt) do
        opt[o] = true
        opt[i] = nil
    end
    vim.keymap.set(mode, lhs, rhs, opt)
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

---Transforms ctx into a human readable representation.
---@vararg any
function _G.dump(...)
    for _, ctx in ipairs({ ... }) do
        print(vim.inspect(ctx))
    end
end

function utils.feedkey(key, mode)
    api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, true, true), mode or "n", true)
end
