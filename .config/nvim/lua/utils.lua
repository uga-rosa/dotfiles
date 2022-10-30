_G.dump = vim.pretty_print

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
