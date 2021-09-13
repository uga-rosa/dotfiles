local neogit = require("neogit")

local map = utils.map

neogit.setup()

map("n", "<leader>n", "Neogit kind=split", "cmd")
