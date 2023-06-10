local helper = require("rc.helper.ddu")

helper.ff_map("file", function(map)
  -- Open file
  map("<C-x>", helper.item_action("open", { command = "split" }))
  map("<C-v>", helper.item_action("open", { command = "vsplit" }))
  -- Send quickfix
  map("q", helper.item_action("quickfix"))
end)

helper.ff_filter_map("file", function(map)
  -- Open file
  map("i", "<C-x>", helper.item_action("open", { command = "split" }))
  map("i", "<C-v>", helper.item_action("open", { command = "vsplit" }))
end)

---@type LazySpec
local spec = {
  {
    "Shougo/ddu-kind-file",
    dependencies = "Shougo/ddu.vim",
    config = function()
      vim.fn["ddu#custom#patch_global"]({
        kindOptions = {
          file = {
            defaultAction = "open",
          },
        },
      })

      vim.fn["ddu#custom#action"]("kind", "file", "openProject", function()
        vim.fn["ddu#ui#do_action"](
          "itemAction",
          { name = "open", params = { command = "tabedit" } }
        )
        local root = vim
          .iter(vim.fs.find({ "init.lua", ".git" }, {
            upward = true,
            path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
          }))
          :map(vim.fs.dirname)
          :totable()[1]
        if root then
          vim.cmd.tcd(root)
        end
        return 0
      end)
    end,
  },
}

return spec
