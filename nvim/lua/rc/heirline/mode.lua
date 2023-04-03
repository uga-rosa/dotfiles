return {
  init = function(self)
    self.mode = vim.fn.mode(1):sub(1, 1)
  end,
  hl = function(self)
    return { fg = self.mode_colors[self.mode] }
  end,
  static = {
    mode_names = {
      n = "NORMAL",
      i = "INSERT",
      v = "VISUAL",
      V = "VISUAL",
      ["\22"] = "VISUAL",
      c = "COMMAND",
      s = "SELECT",
      S = "SELECT",
      ["\19"] = "SELECT",
      R = "REPLACE",
      r = "REPLACE",
      ["!"] = "SHELL",
      t = "TERMINAL",
    },
    mode_colors = {
      n = "fg",
      i = "blue",
      v = "magenta",
      V = "magenta",
      ["\22"] = "magenta",
      c = "red",
      s = "magenta",
      S = "magenta",
      ["\19"] = "magenta",
      R = "orange",
      r = "orange",
      ["!"] = "fg",
      t = "green",
    },
  },
  {
    provider = "",
  },
  {
    provider = function(self)
      return " " .. self.mode_names[self.mode]
    end,
    hl = function(self)
      return { fg = "bg", bg = self.mode_colors[self.mode], bold = true }
    end,
  },
  {
    provider = "",
  },
}
