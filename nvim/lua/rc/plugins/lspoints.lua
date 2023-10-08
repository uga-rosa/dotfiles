---@type LazySpec
local spec = {
  "kuuote/lspoints",
  dev = true,
  dependencies = {
    "denops.vim",
  },
  config = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "DenopsPluginPost:lspoints",
      callback = function()
        vim.fn["lspoints#load_extensions"]({ "nvim_diagnostics", "format", "hover" })
      end,
    })

    local group = vim.api.nvim_create_augroup("lspoints-attach", {})
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "typescript",
      group = group,
      callback = function()
        require("rc.plugins.lspoints.denols").attach()
        require("rc.plugins.lspoints.denols").mapping()
      end,
    })
  end,
}

return spec
