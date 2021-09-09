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

local panda = require("myplug.panda")
local slide_opt = {
  css = false,
  _opt = { "-s", "-t", "revealjs", "-V", "theme=moon" },
}

map("n", "<leader>m", function()
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
      "VimLeavePre",
      "*",
      function()
        panda.terminate()
        panda.unlink()
      end,
    },
    {
      "BufWritePost",
      "*.md",
      function()
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
