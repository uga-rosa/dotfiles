local helper = require("rc.helper.ddu")

helper.ff_map("help", function(map)
  map("<C-x>", helper.item_action("open"))
  map("<C-v>", helper.item_action("vsplit"))
  map("<C-t>", helper.item_action("tabopen"))
end)

helper.ff_filter_map("help", function(map)
  map("i", "<C-x>", helper.item_action("open", nil, true))
  map("i", "<C-v>", helper.item_action("vsplit", nil, true))
  map("i", "<C-t>", helper.item_action("tabopen", nil, true))
end)

---@type LazySpec
local spec = {
  "uga-rosa/ddu-source-help",
  dev = true,
  dependencies = "ddu.vim",
  init = function()
    vim.keymap.set("n", "<Space>h", "<Cmd>Ddu help_tags<CR>")
  end,
  config = function()
    helper.patch_local("help_tags", {
      sources = {
        {
          name = "help",
          options = {
            defaultAction = "open",
          },
        },
      },
    })
  end,
}

return spec
