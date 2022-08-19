_G.utils = {
    keymap = require("utils.keymap"),
}

---Transforms ctx into a human readable representation.
---@vararg any
function _G.dump(...)
    local objects = { ... }
    for i = 1, #objects do
        objects[i] = vim.inspect(objects[i])
    end
    print(table.concat(objects, "\n"))
end
