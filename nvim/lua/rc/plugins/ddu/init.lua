local helper = require("rc.helper.ddu")

---@param lnum number 1-index
---@param dir number
---@param expect string pattern
---@return boolean?
local function peek_line(lnum, dir, expect)
  local next_line = vim.fn.getline(lnum + dir)
  if string.find(next_line, expect) then
    return true
  end
end

---@param dir number
---@return fun(): string
local function move_ignore_dummy(dir)
  return function()
    local lnum = vim.fn.line(".")
    while peek_line(lnum, dir, "^>>.*<<$") do
      lnum = lnum + dir
    end
    lnum = lnum + dir
    if 1 <= lnum and lnum <= vim.fn.line("$") then
      return lnum .. "gg"
    end
    return ""
  end
end

helper.ff_map(nil, function(map)
  -- Highlight cursor line
  vim.opt_local.cursorline = true
  -- Default itemAction
  map("<CR>", helper.item_action("default"))
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
  -- Move cursor ignoring dummy items
  map("j", move_ignore_dummy(1), { expr = true })
  map("k", move_ignore_dummy(-1), { expr = true })
end)

helper.ff_filter_map(nil, function(map)
  -- Default itemAction
  map("i", "<CR>", helper.item_action("default", nil, true))
  map("n", "<CR>", helper.item_action("default"))
  -- Close UI
  map("i", "<C-c>", helper.action("quit", nil, true))
  -- Close filter window
  map("n", "<Esc>", helper.action("closeFilterWindow", nil, true))
  -- Move cursor
  map("i", "<C-n>", helper.execute("normal j"))
  map("i", "<C-p>", helper.execute("normal k"))
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
    name = "ddu.vim",
    dependencies = "vim-denops/denops.vim",
    import = "rc.plugins.ddu",
  },
}

return spec
