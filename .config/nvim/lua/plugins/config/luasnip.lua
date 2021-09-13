local luasnip = require("luasnip")

local map = myutils.map
local augroup = myutils.augroup

map({ "i", "s" }, "<C-j>", function(fallback)
  if luasnip.jumpable(1) then
    luasnip.jump(1)
  else
    fallback()
  end
end)

map({ "i", "s" }, "<C-k>", function(fallback)
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end)

map({ "i", "s" }, "<C-l>", function(fallback)
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  else
    fallback()
  end
end)

require("snippets.uga")

require("luasnip.loaders.from_vscode").load({
  paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
})

augroup({
  luasnip_mysetting = {
    "TextChanged,InsertLeave",
    "*.lua",
    function()
      luasnip.unlink_current_if_deleted()
    end,
  },
})
