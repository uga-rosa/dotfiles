return {
  init = function(self)
    self.mode = vim.fn.mode(1):sub(1, 1)
    if self.mode == "c" and vim.g.searchx_kensaku == 1 then
      self.mode = "k"
    end
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
      k = "MIGEMO",
    },
    mode_colors = {
      n = "fg",
      i = "blue",
      v = "purple",
      V = "purple",
      ["\22"] = "purple",
      c = "red",
      s = "purple",
      S = "purple",
      ["\19"] = "purple",
      R = "orange",
      r = "orange",
      ["!"] = "fg",
      t = "green",
      k = "red",
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
      return { fg = "bg", bg = self.mode_colors[self.mode] }
    end,
  },
  {
    provider = "",
  },
}
