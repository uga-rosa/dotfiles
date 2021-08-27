local map = utils.map

require("trouble").setup({})

map("n", "<leader>x", "<cmd>TroubleToggle<cr>", "noremap")
