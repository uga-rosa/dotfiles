local conditions = require("heirline.conditions")

return {
  init = function(self)
    if vim.bo.filetype == "fzf" then
      self.filename = "fzf-lua"
    else
      self.filename = vim.api.nvim_buf_get_name(0)
    end
  end,
  {
    provider = " \u{E0B0} ", -- [[ ]]
  },
  -- icon
  {
    init = function(self)
      local filename = self.filename
      local extension = vim.fn.fnamemodify(filename, ":e")
      self.icon, self.icon_color =
        require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
      return self.icon and (self.icon .. " ")
    end,
    hl = function(self)
      return { fg = self.icon_color }
    end,
  },
  -- filename
  {
    provider = function(self)
      local filename = vim.fn.fnamemodify(self.filename, ":.")
      if filename == "" then
        return "[No Name]"
      end
      if not conditions.width_percent_below(#filename, 0.25) then
        filename = vim.fn.pathshorten(filename)
      end
      return filename
    end,
    hl = { fg = "fg" },
  },
}
