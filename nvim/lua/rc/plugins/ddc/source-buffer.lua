local helper = require("rc.helper.ddc")

---@type PluginSpec
local spec = {
  "uga-rosa/ddc-source-buffer",
  dev = true,
  dependencies = "ddc.vim",
  config = function()
    helper.patch_global({
      sourceOptions = {
        buffer = { mark = "[Buffer]" },
      },
      sourceParams = {
        buffer = {
          getBufnrs = helper.register(function()
            -- Visible buffers
            return vim
              .iter(vim.api.nvim_tabpage_list_wins(0))
              :map(function(win)
                return vim.api.nvim_win_get_buf(win)
              end)
              :totable()
          end),
        },
      },
    })
  end,
}

return spec
