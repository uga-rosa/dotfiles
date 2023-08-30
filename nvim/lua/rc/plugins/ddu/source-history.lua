local helper = require("rc.helper.ddu")

helper.ff_map("history", function(map)
  map("<C-e>", helper.item_action("edit", nil, false, "ddc#enable_cmdline_completion"))
  map("<C-d>", helper.item_action("delete"))
end)

helper.ff_filter_map("history", function(map)
  map("i", "<C-e>", helper.item_action("edit", nil, true, "ddc#enable_cmdline_completion"))
  map("i", "<C-d>", helper.item_action("delete"))
end)

---@type LazySpec
local spec = {
  {
    "matsui54/ddu-source-command_history",
    dependencies = "ddu.vim",
    init = function()
      vim.keymap.set("n", "q:", "<Cmd>Ddu history:command<CR>")
    end,
    config = function()
      helper.patch_local("history:command", {
        sources = { "command_history" },
        kindOptions = {
          _ = {
            defaultAction = "execute",
          },
        },
      })
    end,
  },
  {
    "uga-rosa/ddu-source-search_history",
    dependencies = "ddu.vim",
    init = function()
      vim.keymap.set("n", "q/", "<Cmd>Ddu history:search<CR>")
    end,
    config = function()
      helper.patch_local("history:search", {
        sources = { "search_history" },
        kindOptions = {
          _ = {
            defaultAction = "execute",
          },
        },
      })
    end,
  },
}

return spec
