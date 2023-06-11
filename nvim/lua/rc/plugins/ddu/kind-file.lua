local helper = require("rc.helper.ddu")

helper.ff_map("file", function(map)
  -- Open file
  map("<C-x>", helper.item_action("open", { command = "split" }))
  map("<C-v>", helper.item_action("open", { command = "vsplit" }))
  map("<C-t>", helper.item_action("openProject"))
  -- Send quickfix
  map("q", helper.item_action("quickfix"))
end)

helper.ff_filter_map("file", function(map)
  -- Open file
  map("i", "<C-x>", helper.item_action("open", { command = "split" }))
  map("i", "<C-v>", helper.item_action("open", { command = "vsplit" }))
  map("i", "<C-t>", helper.item_action("openProject"))
end)

---@type LazySpec
local spec = {
  {
    "Shougo/ddu-kind-file",
    dependencies = "ddu.vim",
    config = function()
      helper.patch_global({
        kindOptions = {
          file = {
            defaultAction = "open",
          },
        },
      })

      vim.af.ddu.custom.action("kind", "file", "openProject", function(args)
        for _, item in ipairs(args.items) do
          local path = item.action.path
            or (item.action.bufnr and vim.api.nvim_buf_get_name(item.action.bufnr))
            or item.word
          if vim.fs.isfile(path) then
            vim.cmd.tabedit(path)

            local root = vim.fs.dirname(vim.fs.find({ "init.lua", ".git" }, {
              upward = true,
              path = vim.fs.dirname(path),
            })[1])
            if root then
              vim.cmd.tcd(root)
            end
          end
        end
        return 0
      end)
    end,
  },
}

return spec
