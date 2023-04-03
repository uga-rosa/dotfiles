local palette = require("nightfox.palette").load("nightfox")

return {
  bg = palette.bg3,
  fg = palette.fg1,
  red = palette.red.base,
  green = palette.green.base,
  blue = palette.blue.base,
  orange = palette.orange.base,
  magenta = palette.magenta.base,
  cyan = palette.cyan.base,
  pink = palette.pink.base,
  diag_warn = palette.yellow.base,
  diag_error = palette.red.bright,
  diag_hint = palette.blue.bright,
  diag_info = palette.white.base,
  git_add = palette.green.base,
  git_change = palette.blue.base,
  git_del = palette.red.base,
}
