local augroup = utils.augroup

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
        require("myplug.pasteimage")
        require("myplug.table")
      end,
    },
  },
})
