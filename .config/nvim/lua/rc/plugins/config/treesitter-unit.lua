local map = utils.keymap.set

local unit = require("treesitter-unit")
map("ox", "iu", function()
    unit.select()
end)
map("ox", "au", function()
    unit.select(true)
end)
