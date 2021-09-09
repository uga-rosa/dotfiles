local augroup = utils.augroup
local map = utils.map

require("myplug.rename").setup()

augroup({
  markdown = {
    {
      "FileType",
      "markdown",
      "++once",
      function()
        vim.g.markdown_fenced_languages = { "lua", "python", "rust" }
      end,
    },
    {
      "FileType",
      "markdown",
      "++once",
      function()
        require("myplug.pasteimage").setup()
        require("myplug.table").setup()
      end,
    },
  },
})

local panda = require("panda")

map("n", "<leader>m", function()
  local firstline = vim.fn.getline(1)
  if firstline:match("^%%") then
    panda.run({ opt = { "--katex", "-s", "-t", "revealjs", "-V", "theme=moon" } })
  else
    panda.run()
  end
end)

augroup({
  panda = {
    {
      "VimLeavePre",
      "*",
      function()
        require("panda").terminate()
        require("panda").unlink()
      end,
    },
    {
      "BufWritePost",
      "*.md",
      function()
        local firstline = vim.fn.getline(1)
        if firstline:match("^%%") then
          panda.convert({ opt = { "--katex", "-s", "-t", "revealjs", "-V", "theme=moon" } })
        else
          panda.convert()
        end
      end,
    },
  },
})
