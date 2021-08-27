local luasnip = require("luasnip")
local map = utils.map
local t = utils.t

map({ "i", "s" }, "<C-j>", function()
  if luasnip.jumpable(1) then
    return t("<Plug>luasnip-jump-next")
  else
    return t("<C-j>")
  end
end, "expr")

map({ "i", "s" }, "<C-k>", function()
  if luasnip.jumpable(-1) then
    return t("<Plug>luasnip-jump-prev")
  else
    return t("<C-k>")
  end
end, "expr")

map({ "i", "s" }, "<C-e>", function()
  if luasnip.choice_active() then
    return t("<Plug>luasnip-next-choice")
  else
    return t("<C-e>")
  end
end, "expr")

map("i", "<esc>", function()
  Luasnip_current_nodes[vim.fn.bufnr("%")] = nil
  return t("<esc>")
end, "expr")

require("snippets")

require("luasnip.loaders.from_vscode").load({
  paths = "~/.snippets",
})
