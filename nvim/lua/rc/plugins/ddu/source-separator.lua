local helper = require("rc.helper.ddu")

---@param items table[] DduItem[]
---@param index number
---@return boolean
local function is_separator(items, index)
  return items[index] and items[index].__sourceName == "separator"
end

---@param dir number
---@return function
local function move_ignore_separator(dir)
  return function()
    local items = vim.fn["ddu#ui#get_items"]()
    local index = vim.fn.line(".") + dir

    while is_separator(items, index) do
      index = index + dir
    end
    if 1 <= index and index <= #items then
      vim.cmd("normal! " .. index .. "gg")
    end
  end
end

helper.ff_map("separator", function(map)
  -- Move cursor ignoring dummy items
  map("j", move_ignore_separator(1))
  map("k", move_ignore_separator(-1))
end)

---@type LazySpec
local spec = {
  {
    "uga-rosa/ddu-source-separator",
    dir = "~/plugin/ddu-source-separator",
    dependencies = "ddu.vim",
    config = function()
      helper.patch_global({
        sourceOptions = {
          separator = {
            matchers = {},
            sorters = {},
            converters = {},
          },
        },
      })
    end,
  },
}

return spec
