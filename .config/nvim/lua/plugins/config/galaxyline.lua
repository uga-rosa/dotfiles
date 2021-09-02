local res, gl = pcall(require, "galaxyline")
local res2, dev = pcall(require, "nvim-web-devicons")
if not (res and res2) then
  return
end

local gls = gl.section
local cond = require("galaxyline.condition")

local icons = {
  sep = {
    right = "",
    left = "",
  },
  diagnostic = {
    error = "",
    warning = "",
    info = "",
  },
  diff = {
    added = "",
    modified = "",
    removed = "",
  },
  git = "",
  devil = "  ",
}

local colors = {
  black = "#011627",
  white = "#c3ccdc",
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
  n = { icons.devil .. "NORMAL ", colors.indigo },
  no = { icons.devil .. "NORMAL  ", colors.indigo },
  i = { icons.devil .. "INSERT  ", colors.ash_blue },
  ic = { icons.devil .. "INSERT  ", colors.ash_blue },
  c = { icons.devil .. "COMMAND ", colors.emerald },
  ce = { icons.devil .. "COMMAND ", colors.emerald },
  cv = { icons.devil .. "COMMAND ", colors.emerald },
  v = { icons.devil .. "VISUAL  ", colors.purple },
  V = { icons.devil .. "VISUAL  ", colors.purple },
  [""] = { icons.devil .. "VISUAL  ", colors.purple },
  R = { icons.devil .. "REPLACE ", colors.red },
  ["r?"] = { icons.devil .. "REPLACE ", colors.red },
  Rv = { icons.devil .. "REPLACE ", colors.red },
  r = { icons.devil .. "REPLACE ", colors.red },
  rm = { icons.devil .. "REPLACE ", colors.red },
  s = { icons.devil .. "SELECT  ", colors.purple },
  S = { icons.devil .. "SELECT  ", colors.purple },
  [""] = { icons.devil .. "SELECT  ", colors.purple },
  t = { icons.devil .. "TERMINAL ", colors.orange },
  ["!"] = { "  !        ", colors.white_blue },
}

local function mode_label()
  return mode_map[vim.fn.mode()][1] or "N/A"
end

local function mode_hl()
  return mode_map[vim.fn.mode()][2] or colors.regal_blue
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

gls.left[1] = {
  leftRounded = {
    provider = function()
      return icons.sep.left
    end,
    highlight = "GalaxyViModeInv",
  },
}

gls.left[2] = {
  ViMode = {
    provider = function()
      highlight("GalaxyViMode", colors.regal_blue, mode_hl(), "bold")
      highlight("GalaxyViModeInv", mode_hl(), "bold")
      return mode_label()
    end,
  },
}

gls.left[3] = {
  WhiteSpace = {
    provider = function()
      highlight("SecondGalaxyViMode", mode_hl(), colors.regal_blue, "bold")
    end,
    separator = icons.sep.right .. " ",
    separator_highlight = "SecondGalaxyViMode",
  },
}

gls.left[4] = {
  FileIcon = {
    provider = "FileIcon",
    condition = cond.buffer_not_empty,
    highlight = {
      require("galaxyline.provider_fileinfo").get_file_icon_color,
      colors.regal_blue,
    },
  },
}

gls.left[5] = {
  FileName = {
    provider = "FileName",
    condition = cond.buffer_not_empty,
    highlight = { colors.watermelon, colors.regal_blue, "bold" },
  },
}
