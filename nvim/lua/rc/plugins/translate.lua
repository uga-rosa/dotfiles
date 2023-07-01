local keys = {}

for k, v in pairs({
  f = "-output=floating",
  s = "-output=split",
  i = "-output=insert",
  r = "-output=replace",
  c = "-comment",
}) do
  vim.list_extend(keys, {
    { "mj" .. k, ("<Cmd>Translate JA -source=EN %s<CR><Esc>"):format(v), mode = { "n", "x" } },
    { "me" .. k, ("<Cmd>Translate EN -source=JA %s<CR><Esc>"):format(v), mode = { "n", "x" } },
  })
end

---@type LazySpec
local spec = {
  {
    "uga-rosa/translate.nvim",
    keys = keys,
    config = function()
      require("translate").setup({
        default = {
          command = "deepl_free",
        },
        preset = {
          output = {
            split = {
              append = true,
            },
          },
        },
      })
    end,
  },
}

return spec
