local M = {}

---@param config table
function M.start(config)
  local sources = {}
  for i, v in ipairs(config) do
    sources[i] = { name = v }
    config[i] = nil
  end
  config.sources = sources
  vim.fn["ddu#start"](config)
end

---@param name string
---@param params table?
---@return function
function M.call_action(name, params)
  return function()
    vim.fn["ddu#ui#ff#do_action"](name, params or vim.empty_dict())
  end
end

---@param name string
---@param params table?
---@return function
function M.itemAction(name, params)
  local opts = {
    name = name,
    params = params,
  }
  return M.call_action("itemAction", opts)
end

function M.open_tab()
  M.itemAction("open", { command = "tabedit" })()
  local root = vim
    .iter(vim.fs.find({ "init.vim", ".git" }, {
      upward = true,
    }))
    :map(vim.fs.dirname)
    :totable()[1]
  if root then
    vim.cmd.tcd(root)
  end
end

---@param cmd string
---@return function
function M.execute(cmd)
  return function()
    vim.fn["ddu#ui#ff#execute"](cmd)
    vim.cmd("redraw!")
  end
end

return M
