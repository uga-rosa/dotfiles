local helper = require("rc.helper.ddu")

helper.ff_map(nil, function(map)
  -- Highlight cursor line
  vim.opt_local.cursorline = true
  -- Enter filter
  map("i", helper.action("openFilterWindow"))
  -- Close UI
  map("<Esc>", helper.action("quit"))
  -- Toggle selected state for all items
  map("a", helper.action("toggleAllItems"))
  -- Toggle selected state for cursor item
  map(" ", helper.action("toggleSelectItem"))
  -- Expand item tree
  map("e", helper.action("expandItem", { mode = "toggle" }))
  -- Default itemAction
  map("<CR>", helper.item_action("default"))
end)

helper.ff_filter_map(nil, function(map)
  -- Close UI
  -- map("i", "<C-c>", "<Esc><Cmd>call ddu#ui#do_action('quit')<CR>")
  map("i", "<C-c>", helper.action('quit'))
  -- Lexima overwrite <Esc> mapping
  vim.b.lexima_disabled = true
  -- Close filter window
  map("n", "<Esc>", helper.action("closeFilterWindow"))
  -- Move cursor
  map("i", "<C-n>", helper.execute("normal! j"))
  map("i", "<C-p>", helper.execute("normal! k"))
  -- Default itemAction
  map("i", "<CR>",  "<Esc><Cmd>call ddu#ui#do_action('itemAction')<CR>")
end)

vim.api.nvim_create_user_command("Ddu", function(args)
  local subcommand = args.args
  local f = require("ddu_command")[subcommand]
  if f then
    f()
  else
    vim.notify("Unknown subcommand: " .. subcommand)
  end
end, {
  nargs = 1,
  complete = function()
    return vim.tbl_keys(require("ddu_command"))
  end,
})

---@type LazySpec
local spec = {
  {
    "Shougo/ddu.vim",
    dependencies = "vim-denops/denops.vim",
    import = "rc.plugins.ddu",
  },
}

return spec
