local lualine_loaded = false

if lualine_loaded then
  return
end
lualine_loaded = true

-- reset
local sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = {},
  lualine_x = {},
  lualine_y = {},
  lualine_z = {},
}

-- insert component
local lhs = function(component)
  sections.lualine_c[#sections.lualine_c + 1] = component
end

local rhs = function(component)
  sections.lualine_z[#sections.lualine_z + 1] = component
end

local icons = {
  diagnostic = {
    error = "  ",
    warning = "  ",
    hint = "  ",
    info = "  ",
  },
  diff = {
    added = " ",
    changed = " ",
    removed = " ",
  },
  git = " ",
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

local highlight_set = function(name, fg, bg)
  vim.cmd(("highlight %s guifg=%s guibg=%s"):format(name, fg, bg))
end

highlight_set("git_added", colors.emerald, colors.bg)
highlight_set("git_changed", colors.yellow, colors.bg)
highlight_set("git_removed", colors.red, colors.bg)

local git_added = function()
  local status = vim.b.gitsigns_status_dict
  if not status then
    return
  end
  local added = status.added
  if added and added ~= 0 then
    return icons.diff.added .. added
  end
end

local git_changed = function()
  local status = vim.b.gitsigns_status_dict
  if not status then
    return
  end
  local changed = status.changed
  if changed and changed ~= 0 then
    return icons.diff.changed .. changed
  end
end

local git_removed = function()
  local status = vim.b.gitsigns_status_dict
  if not status then
    return
  end
  local removed = status.removed
  if removed and removed ~= 0 then
    return icons.diff.removed .. removed
  end
end

lhs({ git_added, color = "git_added" })
lhs({ git_changed, color = "git_changed" })
lhs({ git_removed, color = "git_removed" })

require("lualine").setup({
  options = {
    disabled_filetypes = { "filittle" },
  },
  sections = sections,
})
