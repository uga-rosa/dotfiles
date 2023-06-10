local helper = require("rc.helper.ddu")

helper.ff_map("help", function(map)
  map("<C-x>", helper.item_action("open"))
  map("<C-v>", helper.item_action("vsplit"))
end)

helper.ff_filter_map("help", function(map)
  map("i", "<C-x>", helper.item_action("open"))
  map("i", "<C-v>", helper.item_action("vsplit"))
end)

---@type LazySpec
local spec = {
  {
    "matsui54/ddu-source-help",
    dependencies = "Shougo/ddu.vim",
    init = function()
      vim.keymap.set("n", "<Space>h", "<Cmd>Ddu help_tags<CR>")
    end,
    config = function()
      helper.patch_global({
        kindOptions = {
          help = {
            defaultAction = "open",
          },
        },
      })

      helper.register("help_tags", function()
        helper.start("help", "help", {
          uiParams = {
            ff = {
              onPreview = vim.af.denops.callback.register(function()
                vim.cmd("normal! zt")
              end),
            },
          },
        })
      end)
    end,
  },
}

return spec
