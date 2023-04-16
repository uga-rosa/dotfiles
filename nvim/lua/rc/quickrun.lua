local M = {}

function M.run_under_cursor_block()
  local cursor = vim.fn.getcurpos()
  local row_cursor = cursor[2]

  local code_ranges = require("nvim-treesitter-clipping.internal").get_code_ranges(0)
  for _, d in ipairs(code_ranges) do
    if d.from <= row_cursor and row_cursor <= d.to and d.filetype then
      vim.fn["quickrun#run"]({
        type = d.filetype,
        region = {
          first = { d.from, 0, 0 },
          last = { d.to, 0, 0 },
          wise = "V",
        },
      })
      return
    end
  end
end

return M
