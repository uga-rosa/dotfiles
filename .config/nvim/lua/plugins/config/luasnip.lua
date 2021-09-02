local res, luasnip = pcall(require, "luasnip")
if not res then
  return
end

local map = utils.map
local t = utils.t

map({ "i", "s" }, "<C-j>", function()
  if luasnip.jumpable(1) then
    luasnip.jump(1)
  else
    vim.api.nvim_feedkeys(t("<C-j>"), "n", true)
  end
end)

map({ "i", "s" }, "<C-k>", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    vim.api.nvim_feedkeys(t("<C-k>"), "n", true)
  end
end)

map({ "i", "s" }, "<C-l>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  else
    vim.api.nvim_feedkeys(t("<C-l>"), "n", true)
  end
end)

map("i", "<esc>", function()
  Luasnip_current_nodes[vim.fn.bufnr("%")] = nil
  vim.api.nvim_feedkeys(t("<esc>"), "n", true)
end)

require("snippets")

require("luasnip.loaders.from_vscode").load({
  paths = {
    "~/snippets",
    vim.fn.stdpath("data") .. "/site/pack/packer/opt/friendly-snippets",
  },
})
