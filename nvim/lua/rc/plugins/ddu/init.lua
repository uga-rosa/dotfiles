local helper = require("rc.helper.ddu")

helper.ff_map(nil, function(map)
  -- Highlight cursor line
  vim.opt_local.cursorline = true
  -- Default itemAction
  map("<CR>", helper.item_action("default"))
end)

helper.ff_filter_map(nil, function(map)
  -- Default itemAction
  map("i", "<CR>", helper.item_action("default", nil, true))
  map("n", "<CR>", helper.item_action("default"))
end)

vim.api.nvim_create_user_command("Ddu", function(args)
  local ddu_name = args.args
  vim.fn["ddu#start"]({ name = ddu_name })
end, {
  nargs = 1,
  complete = function()
    return vim.tbl_keys(vim.fn["ddu#custom#get_local"]())
  end,
})

---@type LazySpec
local spec = {
  "Shougo/ddu.vim",
  name = "ddu.vim",
  dependencies = "vim-denops/denops.vim",
  import = "rc.plugins.ddu",
  config = function()
    vim.schedule(vim.fn["ddu#start"])
  end,
}

return spec
