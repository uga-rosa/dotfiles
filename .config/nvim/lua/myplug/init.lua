local M = {}

local augroup = myutils.augroup
local map = myutils.map

local function panda_setup()
  local panda = require("panda")
  panda.setup()

  local slide_opt = {
    css = false,
    _opt = {
      "-s",
      "-t",
      "revealjs",
      "-V",
      "theme=moon",
    },
  }

  map("n", "<leader>pn", function()
    vim.g.panda_started = true
    local firstline = vim.fn.getline(1)
    if firstline:match("^%%") then
      panda.run(slide_opt)
    else
      panda.run()
    end
  end)

  augroup({
    panda = {
      {
        "BufWritePost",
        "*.md",
        function()
          if not vim.g.panda_started then
            return
          end
          local firstline = vim.fn.getline(1)
          if firstline:match("^%%") then
            panda.convert(slide_opt)
          else
            panda.convert()
          end
        end,
      },
    },
  })
end

M.setup = function()
  augroup({
    markdown = {
      {
        "FileType",
        "markdown",
        "++once",
        function()
          vim.g.markdown_fenced_languages = { "lua", "python", "rust" }
          require("myplug.pasteimage").setup()
          require("myplug.table").setup()
          panda_setup()
        end,
      },
    },
  })
  -- toggle terminal
  require("myplug.term")
end

return M
