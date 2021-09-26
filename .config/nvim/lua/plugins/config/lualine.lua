local loaded = false

if loaded then
  return
end
loaded = true

local f = vim.fn

-- reset
local sections = {
  lualine_b = {},
  lualine_c = {},
  lualine_x = {},
  lualine_y = {},
}

-- insert component
local lhs = function(component)
  sections.lualine_c[#sections.lualine_c + 1] = component
end

local rhs = function(component)
  sections.lualine_x[#sections.lualine_x + 1] = component
end

-- highlight setting
local highlight_set = function(name, fg, bg)
  vim.cmd(("highlight! %s guifg=%s guibg=%s"):format(name, fg, bg))
end

local icons = {
  diagnostic = {
    error = "  ",
    warn = "  ",
    hint = "  ",
    info = "  ",
  },
  diff = {
    added = " ",
    changed = " ",
    removed = " ",
  },
}

local colors = {
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

-- theme
local theme = {
  replace = {
    a = { fg = colors.purple, bg = colors.watermelon, gui = "bold" },
    b = { fg = colors.white_blue, bg = colors.bg },
  },
  inactive = {
    a = { fg = colors.cadet_blue, bg = colors.bg, gui = "bold" },
    b = { fg = colors.cadet_blue, bg = colors.bg },
    c = { fg = colors.cadet_blue, bg = colors.bg },
  },
  normal = {
    a = { fg = colors.dark_blue, bg = colors.blue, gui = "bold" },
    b = { fg = colors.white_blue, bg = colors.bg },
    c = { fg = colors.white_blue, bg = colors.bg },
  },
  visual = {
    a = { fg = colors.dark_blue, bg = colors.purple, gui = "bold" },
    b = { fg = colors.white_blue, bg = colors.bg },
  },
  insert = {
    a = { fg = colors.dark_blue, bg = colors.white_blue, gui = "bold" },
    b = { fg = colors.white_blue, bg = colors.bg },
  },
}

-- file name & icon
lhs({
  function()
    local name, ext = f.expand("%:t"), f.expand("%:e")
    if name == "" then
      return
    end
    local icon, icon_color = require("nvim-web-devicons").get_icon_color(name, ext, { default = true })
    if not icon then
      return
    end
    highlight_set("LualineIcon", icon_color, colors.bg)
    return icon
  end,
  color = "LualineIcon",
})

lhs({
  function()
    return f.expand("%:t")
  end,
  color = { fg = colors.violet },
})

lhs({
  "diagnostics",
  sources = { "nvim_lsp" },
  symbols = icons.diagnostic,
  color_error = colors.red,
  color_warn = colors.yellow,
  color_info = colors.blue,
})

----------
-- center
lhs({
  function()
    return "%="
  end,
})

-- lsp servers
lhs({
  function()
    local clients = {}
    for _, client in pairs(vim.lsp.buf_get_clients(0)) do
      clients[#clients + 1] = client.name
    end
    return table.concat(clients, "; ")
  end,
  icon = " LSP:",
  color = { fg = colors.turquoise },
})

----------
-- right

-- git branch
rhs({
  "branch",
  color = { fg = colors.violet },
})

-- git diff
local git_diff = function(kind)
  return function()
    local status = vim.b.gitsigns_status_dict
    if not status then
      return
    end
    local count = status[kind]
    if count and count ~= 0 then
      return icons.diff[kind] .. count
    end
  end
end

rhs({
  git_diff("added"),
  color = "git_added",
})
highlight_set("git_added", colors.emerald, colors.bg)

rhs({
  git_diff("changed"),
  color = "git_changed",
})
highlight_set("git_changed", colors.yellow, colors.bg)

rhs({
  git_diff("removed"),
  color = "git_removed",
})
highlight_set("git_removed", colors.red, colors.bg)

-- initialize
require("lualine").setup({
  options = {
    component_separators = "",
    section_separators = { "", "" },
    theme = theme,
    disabled_filetypes = { "filittle" },
  },
  sections = sections,
})
