local helper = require("rc.helper.ddu")

---@param lnum number 1-index
---@param dir number
---@param expect string pattern
---@return boolean?
local function peek_line(lnum, dir, expect)
  local next_line = vim.fn.getline(lnum + dir)
  if string.find(next_line, expect) then
    return true
  end
end

---@param dir number
---@return function
local function move_ignore_dummy(dir)
  return function()
    local lnum = vim.fn.line(".")
    while peek_line(lnum, dir, "^>>.*<<$") do
      lnum = lnum + dir
    end
    lnum = lnum + dir
    if 1 <= lnum and lnum <= vim.fn.line("$") then
      vim.cmd("normal! " .. lnum .. "gg")
    end
  end
end

helper.ff_map(nil, function(map)
  -- Move cursor ignoring dummy items
  map("j", move_ignore_dummy(1))
  map("k", move_ignore_dummy(-1))
end)

---@type LazySpec
local spec = {
  {
    "uga-rosa/ddu-source-dummy",
    dependencies = "ddu.vim",
    config = function()
      helper.patch_global({
        sourceOptions = {
          dummy = {
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
