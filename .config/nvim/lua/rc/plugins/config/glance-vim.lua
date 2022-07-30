local map = utils.keymap.map

map("n", "<leader>p", function()
    vim.cmd("Glance")
    vim.fn.system("browser http://localhost:8765")
end, "b")
