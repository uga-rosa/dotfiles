---@type LazySpec
local spec = {
  {
    "Shougo/ddu-ui-ff",
    dependencies = "Shougo/ddu.vim",
    config = function()
      local lines = vim.opt.lines:get()
      local height, row = math.floor(lines * 0.8), math.floor(lines * 0.1)
      local columns = vim.opt.columns:get()
      local width, col = math.floor(columns * 0.8), math.floor(columns * 0.1)

      vim.fn["ddu#custom#patch_global"]({
        ui = "ff",
        uiParams = {
          ff = {
            startFilter = true,
            prompt = "> ",
            split = "floating",
            winHeight = height,
            winRow = row,
            winWidth = width,
            winCol = col,
            floatingBorder = "single",
            filterFloatingPosition = "top",
            autoAction = {
              name = "preview",
            },
            previewFloating = true,
            previewFloatingBorder = "single",
            previewSplit = "vertical",
            previewFloatingTitle = "Preview",
            previewWidth = math.floor(width / 2),
            highlights = {
              floating = "Normal",
              floatingBorder = "Normal",
            },
            ignoreEmpty = true,
          },
        },
      })
    end,
  },
}

return spec
