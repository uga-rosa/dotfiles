local M = {}

---@param parent string[]
---@return DdcItem[]
function M.items(parent)
  local target = _G
  local target_keys = vim.tbl_keys(target)
  for _, name in ipairs(parent) do
    if type(target[name]) == "table" then
      target = target[name]
      target_keys = vim.tbl_keys(target)
    else
      return {}
    end
  end

  local items = {}
  for _, key in ipairs(target_keys) do
    if string.find(key, "^%a[%a_]*$") then
      table.insert(items, M.item(key, target[key]))
    end
  end
  for _, key in ipairs(target_keys) do
    if not string.find(key, "^%a[%a_]*$") then
      table.insert(items, M.item(key, target[key]))
    end
  end

  return items
end

-- :h luaref-type()
M.kind_map = {
  ["nil"] = "Value",
  number = "Value",
  string = "Value",
  boolean = "Value",
  table = "Struct",
  ["function"] = "Function",
  thread = "Field",
  userdata = "Field",
}

---@param key unknown
---@param value unknown
---@return DdcItem
function M.item(key, value)
  key = tostring(key)
  return {
    word = key,
    kind = M.kind_map[type(value)],
  }
end

return M
