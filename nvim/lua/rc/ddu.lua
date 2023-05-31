local M = {
  cb = {},
}

---@class Source
---@field [1] string
---@field name string
---@field param table

---@param source string|Source
---@param config table|nil
function M.start(source, config)
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
  vim.fn["ddu#start"](config)
end

---@param name string
---@param params table
---@return function
function M.wrap_action(name, params)
  return function()
    vim.fn["ddu#ui#do_action"](name, params)
  end
end

---@param action string
---@param params? table
---@param from_insert? boolean
---@return string
function M.map_action(action, params, from_insert)
  local cmd = ""
  if from_insert then
    cmd = "<Esc>"
  end
  if params == nil then
    cmd = cmd .. ("<Cmd>call ddu#ui#do_action('%s')<CR>"):format(action)
  else
    local id = #M.cb + 1
    M.cb[id] = M.wrap_action(action, params)
    cmd = cmd .. ("<Cmd>lua require('rc.ddu').cb[%d]()<CR>"):format(id)
  end
  return cmd
end

---@param name string
---@param params? table
---@param from_insert? boolean
---@return string
function M.map_item_action(name, params, from_insert)
  return M.map_action("itemAction", { name = name, params = params }, from_insert)
end

---@param cmd string
---@return string
function M.map_execute(cmd)
  return ("<Cmd>call ddu#ui#ff#execute('%s')<CR><Cmd>redraw<CR>"):format(cmd)
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

function M.history_mapping()
  local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true, nowait = true })
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "ddu-ff",
    callback = function()
      map("n", "<C-e>", M.map_item_action("edit"))
      map("n", "<C-d>", M.map_item_action("delete"))
    end,
    once = true,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "ddu-ff-filter",
    callback = function()
      map("i", "<C-e>", M.map_item_action("edit"))
      map("i", "<C-d>", M.map_item_action("delete"))
    end,
    once = true,
  })
end

return M
