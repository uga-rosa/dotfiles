---@type PluginSpec
local spec = {
  {
    "lambdalisue/fern.vim",
    cmd = "Fern",
    dependencies = {
      -- "lambdalisue/nerdfont.vim",
      -- "lambdalisue/fern-renderer-nerdfont.vim",
    },
    init = function()
      vim.g["fern#renderer"] = "nerdfont"
      vim.keymap.set("n", "<M-f>", "<Cmd>Fern . -drawer -toggle<CR>")
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "fern",
        group = vim.api.nvim_create_augroup("my-fern", {}),
        callback = function()
          vim.keymap.set("n", "<C-x>", "<Plug>(fern-action-open:split)", { buffer = true })
          vim.keymap.set("n", "<C-v>", "<Plug>(fern-action-open:vsplit)", { buffer = true })
        end,
      })
    end,
  },
}

return spec
