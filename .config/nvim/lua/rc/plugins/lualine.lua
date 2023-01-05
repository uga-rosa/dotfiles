local function safe_call(fn, ...)
  if vim.fn[fn] ~= nil then
    return vim.call(fn, ...)
  else
    vim.notify("Invalid function name: " .. fn)
  end
end

local color = {
  bg = "#1d3b53",
  dark_blue = "#092236",
  cadet_blue = "#a1aab8",
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

local theme = {
  normal = {
    a = { bg = color.indigo, fg = color.dark_blue, gui = "bold" },
    b = { bg = color.bg, fg = color.purple },
    c = { bg = color.bg, fg = color.cadet_blue },
  },
  insert = {
    a = { bg = color.cadet_blue, fg = color.dark_blue, gui = "bold" },
    b = { bg = color.bg, fg = color.purple },
    c = { bg = color.bg, fg = color.cadet_blue },
  },
  visual = {
    a = { bg = color.purple, fg = color.dark_blue, gui = "bold" },
    b = { bg = color.bg, fg = color.purple },
    c = { bg = color.bg, fg = color.cadet_blue },
  },
  replace = {
    a = { bg = color.watermelon, fg = color.dark_blue, gui = "bold" },
    b = { bg = color.bg, fg = color.purple },
    c = { bg = color.bg, fg = color.cadet_blue },
  },
  command = {
    a = { bg = color.emerald, fg = color.dark_blue, gui = "bold" },
    b = { bg = color.bg, fg = color.purple },
    c = { bg = color.bg, fg = color.cadet_blue },
  },
  inactive = {
    a = { bg = color.bg, fg = color.dark_blue, gui = "bold" },
    b = { bg = color.bg, fg = color.purple },
    c = { bg = color.bg, fg = color.cadet_blue },
  },
}

require("lualine").setup({
  options = {
    disabled_filetypes = {
      statusline = {
        "quickrun",
      },
    },
    refresh = {
      statusline = 100,
    },
    theme = theme,
  },
  sections = {
    lualine_a = { function()
      local mode = safe_call("skkeleton#mode") or ""
      if mode == "" then
        mode = require("lualine.utils.mode").get_mode()
      else
        mode = ("skk (%s)"):format(mode)
      end
      return mode
    end },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filetype", "filename" },
    lualine_x = {},
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
