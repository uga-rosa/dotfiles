local f = vim.fn

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

local mode_alias = {
  ["n"] = "NORMAL",
  ["no"] = "OP",
  ["nov"] = "OP",
  ["noV"] = "OP",
  ["no"] = "OP",
  ["niI"] = "NORMAL",
  ["niR"] = "NORMAL",
  ["niV"] = "NORMAL",
  ["nt"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "LINES",
  [""] = "BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT",
  [""] = "BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["ix"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rc"] = "REPLACE",
  ["Rv"] = "V-REPLACE",
  ["Rx"] = "REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "COMMAND",
  ["ce"] = "COMMAND",
  ["r"] = "ENTER",
  ["rm"] = "MORE",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERM",
  ["null"] = "NONE",
}

local vi_mode_colors = {
  NORMAL = colors.indigo,
  OP = colors.indigo,
  INSERT = colors.white_blue,
  VISUAL = colors.purple,
  BLOCK = colors.purple,
  REPLACE = colors.watermelon,
  ["V-REPLACE"] = colors.watermelon,
  ENTER = colors.yellow,
  MORE = colors.yellow,
  SELECT = colors.watermelon,
  COMMAND = colors.emerald,
  SHELL = colors.emerald,
  TERM = colors.emerald,
  NONE = colors.yellow,
}

local function get_vim_mode()
  local mode = vim.api.nvim_get_mode().mode
  if mode then
    return mode_alias[mode]
  end
end

local function get_mode_color()
  local mode = get_vim_mode()
  if mode then
    return vi_mode_colors[mode] or colors.bg
  end
end

local scroll_bar_blocks = { "█", "▇", "▆", "▅", "▄", "▃", "▂", "▁", " " }

local lsp = require("feline.providers.lsp")
local git = require("feline.providers.git")
local devicons = require("nvim-web-devicons")

local comps = {
  vi_mode = {
    provider = function()
      local mode = get_vim_mode()
      mode = mode or "TERM"
      if mode then
        return "  " .. mode .. " "
      end
    end,
    hl = function()
      return {
        fg = colors.dark_blue,
        bg = get_mode_color(),
      }
    end,
    right_sep = " ",
  },
  file = {
    name = {
      provider = function()
        return f.expand("%:t")
      end,
      hl = {
        fg = colors.purple,
        style = "bold",
      },
    },
    icon = {
      provider = function()
        local icon, _ = devicons.get_icon(f.expand("%:t"))
        return icon or ""
      end,
      hl = function()
        local _, cc = devicons.get_icon_color(f.expand("%:t"))
        return {
          fg = cc,
        }
      end,
      right_sep = " ",
    },
    fullpath = {
      provider = function()
        return f.expand("%:p")
      end,
      hl = {
        fg = colors.emerald,
      },
    },
  },
  lsp = {
    servers = {
      provider = "lsp_client_names",
      icon = "  ",
      hl = {
        fg = colors.emerald,
      },
    },
    error = {
      provider = "diagnostic_errors",
      icon = icons.diagnostic.error,
      enabled = function()
        return lsp.diagnostics_exist("Error")
      end,
      hl = {
        fg = colors.red,
      },
    },
    warn = {
      provider = "diagnostic_warnings",
      icon = icons.diagnostic.warn,
      enabled = function()
        return lsp.diagnostics_exist("Warning")
      end,
      hl = {
        fg = colors.yellow,
      },
    },
    hint = {
      provider = "diagnostic_hints",
      icon = icons.diagnostic.hint,
      enabled = function()
        return lsp.diagnostics_exist("Hint")
      end,
      hl = {
        fg = colors.white_blue,
      },
    },
    info = {
      provider = "diagnostic_info",
      icon = icons.diagnostic.info,
      enabled = function()
        return lsp.diagnostics_exist("Information")
      end,
      hl = {
        fg = colors.blue,
      },
    },
  },
  git = {
    branch = {
      provider = function()
        local head, icon = git.git_branch(0)
        return icon .. head
      end,
      enabled = function()
        return git.git_branch(0) ~= ""
      end,
      hl = {
        fg = colors.purple,
      },
    },
    diff = {
      add = {
        provider = function()
          return git.git_diff_added(0)
        end,
        icon = icons.diff.added,
        enabled = function()
          return git.git_diff_added(0) ~= ""
        end,
        hl = {
          fg = colors.green,
        },
        left_sep = " ",
      },
      change = {
        provider = function()
          return git.git_diff_changed(0)
        end,
        icon = icons.diff.changed,
        enabled = function()
          return git.git_diff_changed(0) ~= ""
        end,
        hl = {
          fg = colors.yellow,
        },
        left_sep = " ",
      },
      remove = {
        provider = function()
          return git.git_diff_removed(0)
        end,
        icon = icons.diff.removed,
        enabled = function()
          return git.git_diff_removed(0) ~= ""
        end,
        hl = {
          fg = colors.red,
        },
        left_sep = " ",
      },
    },
  },
  cursor = {
    pos_per = {
      provider = function()
        local c = require("feline.providers.cursor")
        return " " .. c.position() .. " " .. c.line_percentage() .. " "
      end,
      hl = {
        fg = colors.bg,
        bg = colors.emerald,
      },
      left_sep = " ",
    },
    bar = {
      provider = function()
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        return string.rep(scroll_bar_blocks[math.floor(curr_line / lines * 8) + 1], 2)
      end,
      hl = {
        fg = colors.bg,
        bg = colors.emerald,
      },
    },
  },
}

local components = {
  active = { {}, {}, {} },
  inactive = { {}, {}, {} },
}

function components.active_add(self, n, x)
  self.active[n][#self.active[n] + 1] = x
end

function components.inactive_add(self, n, x)
  self.inactive[n][#self.inactive[n] + 1] = x
end

components:active_add(1, comps.vi_mode)
components:active_add(1, comps.file.icon)
components:active_add(1, comps.file.name)
components:active_add(1, comps.lsp.error)
components:active_add(1, comps.lsp.warn)
components:active_add(1, comps.lsp.hint)
components:active_add(1, comps.lsp.info)
components:active_add(2, comps.git.branch)
components:active_add(2, comps.git.diff.add)
components:active_add(2, comps.git.diff.change)
components:active_add(2, comps.git.diff.remove)
components:active_add(3, comps.lsp.servers)
components:active_add(3, comps.cursor.pos_per)
components:active_add(3, comps.cursor.bar)
components:inactive_add(1, comps.file.fullpath)

require("feline").setup({
  colors = { bg = colors.bg },
  components = components,
  force_inactive = {
    filetypes = {
      "filittle",
      "quickrun",
    },
  },
})
