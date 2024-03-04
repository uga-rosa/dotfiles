---@type PluginSpec
local spec = {
  "vim-denops/denops.vim",
  name = "denops.vim",
  setup = function()
    vim.g["denops#server#deno_args"] = { "-q", "--no-lock", "-A", "--unstable-kv" }
  end,
}

return spec
