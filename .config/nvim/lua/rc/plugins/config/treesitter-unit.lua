local map = Keymap.set

local unit = require("treesitter-unit")
map("ox", "iu", function()
    unit.select()
end)
map("ox", "au", function()
    unit.select(true)
end)
