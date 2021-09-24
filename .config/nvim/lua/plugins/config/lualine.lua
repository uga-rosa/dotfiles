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
    local buf_ft = vim.bo.filetype
    local lsp = vim.tbl_map(function(client)
      local filetypes = client.config.filetypes
      if vim.tbl_contains(filetypes, buf_ft) then
        return client.name
      end
    end, vim.lsp.get_active_clients())
    return table.concat(lsp, "; ")
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
rhs({
  function()
    local status = vim.b.gitsigns_status_dict
    if not status then
      return
    end
    local added = status.added
    if added and added ~= 0 then
      return icons.diff.added .. added
    end
  end,
  color = "git_added",
})
highlight_set("git_added", colors.emerald, colors.bg)

rhs({
  function()
    local status = vim.b.gitsigns_status_dict
    if not status then
      return
    end
    local changed = status.changed
    if changed and changed ~= 0 then
      return icons.diff.changed .. changed
    end
  end,
  color = "git_changed",
})
highlight_set("git_changed", colors.yellow, colors.bg)

rhs({
  function()
    local status = vim.b.gitsigns_status_dict
    if not status then
      return
    end
    local removed = status.removed
    if removed and removed ~= 0 then
      return icons.diff.removed .. removed
    end
  end,
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
