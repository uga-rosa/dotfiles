local res, luasnip = pcall(require, "luasnip")
if not res then
  return
end

local map = utils.map

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

map("i", "<esc>", function(fallback)
  Luasnip_current_nodes[vim.fn.bufnr("%")] = nil
  fallback()
end)

require("snippets")

require("luasnip.loaders.from_vscode").load({
  paths = { "~/snippets" },
})
