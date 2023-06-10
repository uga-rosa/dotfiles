local M = {}

---@class Source
---@field [1] string
---@field name string
---@field param table

---@param name string
---@param source string|Source
---@param config? table
function M.start(name, source, config)
  config = config or {}
  local sources = {}
  if type(source) == "string" then
    sources = { { name = source } }
  else
    if source[1] then
      source.name = source[1]
      source[1] = nil
    end
    sources = { source }
  end
  config.sources = sources
  config.name = name
  vim.fn["ddu#start"](config)
end

function M.subcommand(subcommand, callback)
  require("rc.utils").package_set("ddu_command", subcommand, callback)
end

---@param name string
---@param params? table
---@return function
function M.action(name, params)
  return function()
    vim.cmd.stopinsert()
    vim.schedule(function()
      vim.fn["ddu#ui#do_action"](name, params or vim.empty_dict())
    end)
  end
end

---@param name string
---@param params? table
---@return function
function M.item_action(name, params)
  return M.action("itemAction", { name = name, params = params })
end

---@param cmd string
---@return function
function M.execute(cmd)
  return function()
    vim.fn["ddu#ui#ff#execute"](cmd)
    vim.cmd.redraw()
  end
end

function M.open_tab()
  M.wrap_action("itemAction", { name = "open", params = { command = "tabedit" } })()
  local root = vim
    .iter(vim.fs.find({ "init.vim", ".git" }, {
      upward = true,
      path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
    }))
    :map(vim.fs.dirname)
    :totable()[1]
  if root then
    vim.cmd.tcd(root)
  end
end

---@param name? string If nil, map is set globally
---@param callback fun(map: fun(lhs: string, rhs: string|function))
function M.ff_map(name, callback)
  name = name or "default"
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "ddu-ff",
    group = vim.api.nvim_create_augroup("ddu-ui-ff-map-" .. name, {}),
    callback = function()
      -- Enable `file` map also for `file:foo`
      if name == "default" or vim.startswith(vim.b.ddu_ui_name, name) then
        callback(function(lhs, rhs)
          vim.keymap.set("n", lhs, rhs, { nowait = true, buffer = true, silent = true })
        end)
      end
    end,
  })
end

---@param name? string If nil, map is set globally
---@param callback fun(map: fun(mode: string|string[], lhs: string, rhs: string|function))
function M.ff_filter_map(name, callback)
  name = name or "default"
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "ddu-ff-filter",
    group = vim.api.nvim_create_augroup("ddu-ui-ff-filter-map-" .. name, {}),
    callback = function()
      -- Enable `file` map also for `file:foo`
      if name == "default" or vim.startswith(vim.b.ddu_ui_name, name) then
        callback(function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { nowait = true, buffer = true, silent = true })
        end)
      end
    end,
  })
end

return M
