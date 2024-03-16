---@type PluginSpec
local spec = {
  "hrsh7th/nvim-insx",
  config = function()
    local insx = require("insx")
    local esc = insx.helper.regex.esc

    insx.add(
      "<",
      insx.with(
        require("insx.recipe.substitute")({
          pattern = [[\S\zs\%#]],
          replace = [[<\%#>]],
        }),
        {
          insx.with.filetype({ "typescript", "typescriptreact" }),
        }
      )
    )
    insx.add(
      "<BS>",
      insx.with(
        require("insx.recipe.delete_pair")({
          open_pat = esc("<"),
          close_pat = esc(">"),
        }),
        {
          insx.with.filetype({ "typescript", "typescriptreact" }),
        }
      )
    )

    require("insx.preset.standard").setup()

    vim.cmd("do User LazyPluginPost:insx")
  end,
}

return spec
