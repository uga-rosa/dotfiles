local gl = require("galaxyline")
local gls = gl.section
local cond = require("galaxyline.condition")

local icons = {
  round = {
    right = "",
    left = "",
  },
  diagnostic = {
    error = "  ",
    warning = "  ",
    hint = "  ",
    info = "  ",
  },
  diff = {
    added = " ",
    modified = " ",
    removed = " ",
  },
  git = " ",
  devil = " ",
}

local colors = {
  bg = "#1d3b53",
  black_blue = "#081e2f",
  dark_blue = "#092236",
  deep_blue = "#0e293f",
  slate_blue = "#2c3043",
  regal_blue = "#1d3b53",
  cyan_blue = "#296596",
  steel_blue = "#4b6479",
  grey_blue = "#7c8f8f",
  cadet_blue = "#a1aab8",
  ash_blue = "#acb4c2",
  white_blue = "#d6deeb",
  yellow = "#e3d18a",
  peach = "#ffcb8b",
  tan = "#ecc48d",
  orange = "#f78c6c",
  red = "#fc514e",
  watermelon = "#ff5874",
  violet = "#c792ea",
  purple = "#ae81ff",
  indigo = "#5e97ec",
  blue = "#82aaff",
  turquoise = "#7fdbca",
  emerald = "#21c7a8",
  green = "#a1cd5e",
}

local mode_map = {
  n = { icons.devil .. "NORMAL", colors.indigo },
  no = { icons.devil .. "NORMAL", colors.indigo },
  i = { icons.devil .. "INSERT", colors.ash_blue },
  ic = { icons.devil .. "INSERT", colors.ash_blue },
  c = { icons.devil .. "COMMAND", colors.emerald },
  ce = { icons.devil .. "COMMAND", colors.emerald },
  cv = { icons.devil .. "COMMAND", colors.emerald },
  v = { icons.devil .. "VISUAL", colors.purple },
  V = { icons.devil .. "VISUAL", colors.purple },
  [""] = { icons.devil .. "VISUAL", colors.purple },
  R = { icons.devil .. "REPLACE", colors.red },
  ["r?"] = { icons.devil .. "REPLACE", colors.red },
  Rv = { icons.devil .. "REPLACE", colors.red },
  r = { icons.devil .. "REPLACE", colors.red },
  rm = { icons.devil .. "REPLACE", colors.red },
  s = { icons.devil .. "SELECT", colors.purple },
  S = { icons.devil .. "SELECT", colors.purple },
  [""] = { icons.devil .. "SELECT", colors.purple },
  t = { icons.devil .. "TERMINAL", colors.orange },
}

local function mode_label()
  return mode_map[vim.fn.mode()][1] or "N/A"
end

local function mode_hl()
  return mode_map[vim.fn.mode()][2] or colors.bg
end

local function highlight(...)
  local args = { ... }
  local cmd = ("highlight %s guifg=%s"):format(args[1], args[2])
  if #args == 3 then
    cmd = cmd .. " gui=" .. args[3]
  elseif #args == 4 then
    cmd = cmd .. (" guibg=%s gui=%s"):format(args[3], args[4])
  end
  vim.cmd(cmd)
end

local i = 1

gls.left[i] = {
  RoundLeft = {
    provider = function()
      return icons.round.left
    end,
    highlight = "GalaxyViModeInv",
  },
}

i = i + 1
gls.left[i] = {
  ViMode = {
    provider = function()
      highlight("GalaxyViMode", colors.black_blue, mode_hl(), "bold")
      highlight("GalaxyViModeInv", mode_hl(), "bold")
      return mode_label()
    end,
    highlight = "GalaxyViMode",
  },
}

i = i + 1
gls.left[i] = {
  RoundRight = {
    provider = function()
      highlight("SecondGalaxyViMode", mode_hl(), colors.bg, "bold")
    end,
    separator = icons.round.right .. " ",
    separator_highlight = "SecondGalaxyViMode",
  },
}

i = i + 1
gls.left[i] = {
  FileIcon = {
    provider = "FileIcon",
    condition = cond.buffer_not_empty,
    highlight = {
      require("galaxyline.provider_fileinfo").get_file_icon_color,
      colors.bg,
    },
  },
}

i = i + 1
gls.left[i] = {
  FileName = {
    provider = "FileName",
    condition = cond.buffer_not_empty,
    highlight = { colors.violet, colors.bg, "bold" },
  },
}

i = i + 1
gls.left[i] = {
  DiagnosticError = {
    icon = icons.diagnostic.error,
    provider = "DiagnosticError",
    condition = cond.buffer_not_empty,
    highlight = { colors.red, colors.bg },
  },
}

i = i + 1
gls.left[i] = {
  DiagnosticWarn = {
    icon = icons.diagnostic.warning,
    provider = "DiagnosticWarn",
    condition = cond.buffer_not_empty,
    highlight = { colors.orange, colors.bg },
  },
}

i = i + 1
gls.left[i] = {
  DiagnosticHint = {
    icon = icons.diagnostic.hint,
    provider = "DiagnosticHint",
    condition = cond.buffer_not_empty,
    highlight = { colors.turquoise, colors.bg },
  },
}

i = i + 1
gls.left[i] = {
  DiagnosticInfo = {
    icon = icons.diagnostic.info,
    provider = "DiagnosticInfo",
    condition = cond.buffer_not_empty,
    highlight = { colors.blue, colors.bg },
  },
}

i = 1
gls.right[i] = {
  GitIcon = {
    provider = function()
      return icons.git
    end,
    condition = cond.buffer_not_empty,
    highlight = { colors.purple, colors.bg },
  },
}

i = i + 1
gls.right[i] = {
  GitBranch = {
    provider = {
      "GitBranch",
      function()
        return " "
      end,
    },
    condition = cond.buffer_not_empty,
    highlight = { colors.purple, colors.bg },
  },
}

i = i + 1
gls.right[i] = {
  DiffAdd = {
    icon = icons.diff.added,
    provider = "DiffAdd",
    condition = cond.buffer_not_empty,
    highlight = { colors.green, colors.bg },
  },
}

i = i + 1
gls.right[i] = {
  DiffModified = {
    icon = icons.diff.modified,
    provider = "DiffModified",
    condition = cond.buffer_not_empty,
    highlight = { colors.orange, colors.bg },
  },
}

i = i + 1
gls.right[i] = {
  DiffRemove = {
    icon = icons.diff.removed,
    provider = "DiffRemove",
    condition = cond.buffer_not_empty,
    highlight = { colors.red, colors.bg },
  },
}

i = i + 1
gls.right[i] = {
  LineColumn = {
    provider = "LineColumn",
    condition = cond.buffer_not_empty,
    highlight = { colors.black_blue, colors.purple },
    separator = icons.round.left,
    separator_highlight = { colors.purple, colors.bg },
  },
}

i = i + 1
gls.right[i] = {
  LinePercent = {
    provider = {
      "LinePercent",
      function()
        return "▊"
      end,
    },
    highlight = { colors.purple, colors.bg },
    separator = icons.round.left,
    separator_highlight = { colors.bg, colors.purple },
  },
}
