local M = {}

---@param config table
function M.start(config)
  local sources = {}
  for k, v in pairs(config) do
    if type(k) == "number" then
      sources[k] = { name = v }
      config[k] = nil
    end
  end
  config.sources = sources
  vim.fn["ddu#start"](config)
end

return M
