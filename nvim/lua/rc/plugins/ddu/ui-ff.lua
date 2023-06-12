local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  {
    "Shougo/ddu-ui-ff",
    dependencies = "ddu.vim",
    config = function()
      helper.patch_global({
        ui = "ff",
        uiParams = {
          ff = {
            startFilter = true,
            prompt = "> ",
            split = "floating",
            floatingBorder = "single",
            filterFloatingPosition = "top",
            autoAction = {
              name = "preview",
            },
            previewFloating = true,
            previewFloatingBorder = "single",
            previewSplit = "vertical",
            previewFloatingTitle = "Preview",
            previewWindowOptions = {
              { "&signcolumn", "no" },
              { "&foldcolumn", 0 },
              { "&foldenable", 0 },
              { "&number", 0 },
              { "&wrap", 0 },
              { "&scrolloff", 0 },
            },
            highlights = {
              floating = "Normal",
              floatingBorder = "Normal",
            },
            ignoreEmpty = true,
          },
        },
      })

      local function resize()
        local lines = vim.opt.lines:get()
        local height, row = math.floor(lines * 0.8), math.floor(lines * 0.1)
        local columns = vim.opt.columns:get()
        local width, col = math.floor(columns * 0.8), math.floor(columns * 0.1)

        helper.patch_global({
          uiParams = {
            ff = {
              winHeight = height,
              winRow = row,
              winWidth = width,
              winCol = col,
              previewWidth = math.floor(width / 2),
              previewHeight = height,
            },
          },
        })
      end
      resize()

      vim.api.nvim_create_autocmd("VimResized", {
        callback = resize,
      })
    end,
  },
}

return spec
