local command = myutils.command

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
