local helper = require("rc.helper.ddu")

helper.ff_map("history", function(map)
  map("<C-e>", helper.item_action("edit"))
  map("<C-d>", helper.item_action("delete"))
end)

helper.ff_filter_map("history", function(map)
  map("i", "<C-e>", helper.item_action("edit"))
  map("i", "<C-d>", helper.item_action("delete"))
end)

---@type LazySpec
local spec = {
  {
    "matsui54/ddu-source-command_history",
    dependencies = "Shougo/ddu.vim",
    init = function()
      vim.keymap.set("n", "q:", "<Cmd>Ddu command_history<CR>")
    end,
    config = function()
      helper.register("command_history", function()
        helper.start("history", "command_history", {
          kindOptions = {
            _ = {
              defaultAction = "execute",
            },
          },
        })
      end)
    end,
  },
  {
    "uga-rosa/ddu-source-search_history",
    dependencies = "Shougo/ddu.vim",
    init = function()
      vim.keymap.set("n", "q/", "<Cmd>Ddu search_history<CR>")
    end,
    config = function()
      helper.register("search_history", function()
        helper.start("history", "search_history", {
          kindOptions = {
            _ = {
              defaultAction = "execute",
            },
          },
        })
      end)
    end,
  },
}

return spec
