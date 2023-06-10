--[[
From windwp/nvim-autopairs

MIT License

Copyright (c) 2021 windwp

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local handlers = require("rc.autopairs.handlers")
local cmp = require("cmp")

local Kind = cmp.lsp.CompletionItemKind

local M = {}

M.filetypes = {
  -- Alias to all filetypes
  ["*"] = {
    ["("] = {
      kind = { Kind.Function, Kind.Method },
      handler = handlers["*"],
    },
  },
  clojure = {
    ["("] = {
      kind = { Kind.Function, Kind.Method },
      handler = handlers.lisp,
    },
  },
  clojurescript = {
    ["("] = {
      kind = { Kind.Function, Kind.Method },
      handler = handlers.lisp,
    },
  },
  fennel = {
    ["("] = {
      kind = { Kind.Function, Kind.Method },
      handler = handlers.lisp,
    },
  },
  janet = {
    ["("] = {
      kind = { Kind.Function, Kind.Method },
      handler = handlers.lisp,
    },
  },
  tex = false,
}

M.on_confirm_done = function(opts)
  opts = vim.tbl_deep_extend("force", {
    filetypes = M.filetypes,
  }, opts or {})

  return function(evt)
    local entry = evt.entry
    local commit_character = evt.commit_character
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    local item = entry:get_completion_item()

    -- Without options and fallback
    if not opts.filetypes[filetype] and not opts.filetypes["*"] then
      return
    end

    if opts.filetypes[filetype] == false then
      return
    end

    -- If filetype is nil then use *
    local completion_options = opts.filetypes[filetype] or opts.filetypes["*"]

    for char, value in pairs(completion_options) do
      if vim.tbl_contains(value.kind, item.kind) then
        value.handler(char, item, bufnr, commit_character)
      end
    end
  end
end

return M
