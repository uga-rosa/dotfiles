local command = myutils.command

vim.g.coc_start_at_startup = 0

command({
  "Switch2coc",
  function()
    require("cmp").setup.buffer({ enabled = false })
    vim.cmd("CocEnable")
  end,
})

command({
  "Switch2cmp",
  function()
    require("cmp").setup.buffer({ enabled = true })
    vim.cmd("CocDisable")
  end,
})
