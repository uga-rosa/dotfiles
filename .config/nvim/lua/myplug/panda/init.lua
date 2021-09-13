local M = {}

local fn = vim.fn
local uv = vim.loop

local augroup = myutils.augroup

local css_dir = fn.stdpath("config") .. "/lua/myplug/panda/css/"

local settings = {
  css = true,
  _css_path = {
    github_dark = css_dir .. "github_dark.css",
    github_light = css_dir .. "github_light.css",
  },
  css_path = {},
  css_name = "github_dark",
  update = true,
  ext = { "md" },
  browser = "chrome.exe",
  opt = {
    "--katex",
  },
}

function settings:get_css_path(css_name)
  css_name = css_name or self.css_name
  return self.css_path[css_name] or self._css_path[css_name]
end

local get_boolen = function(opts, default, name)
  if opts[name] == nil then
    return default[name]
  else
    return opts[name]
  end
end

local output = {}

---@param opts table
--- opts.dir: output directory
--- opts.name: output file name (without extension)
--- opts.css: overwrite css
--- opts.css_name: overwrite css_name
--- opts.update: overwrite update
--- opts.browser: overwrite browser
--- opts.opt: overwrite opt
--- opts.\_opt: add pandoc option (merge with settings.opt, not overwrite)
M.convert = function(opts)
  opts = opts or {}

  local dir = opts.dir or ""
  dir = dir:gsub("/$", "")

  local fullpath = fn.expand("%:p")

  local ext = fn.fnamemodify(fullpath, ":e")
  assert(vim.tbl_contains(settings.ext, ext), "Extension not set: " .. ext)

  output.name = (opts.name or fn.fnamemodify(fullpath, ":t:r")) .. ".html"

  output.parent = (function()
    if dir:match("^/") then
      return dir
    elseif dir == "" then
      return "/tmp"
    else
      local parent = fn.fnamemodify(fullpath, ":h")
      return ("%s/%s"):format(parent, dir)
    end
  end)()

  output.path = output.parent .. "/" .. output.name

  output.browser = opts.browser or settings.browser

  local update = get_boolen(opts, settings, "update")
  if not update and fn.filereadable(output.path) then
    error(output.path .. " already exists.")
  end

  local opt = {
    fullpath,
    "-o",
    output.path,
    "-H",
    css_dir .. "livejs",
  }

  local css = get_boolen(opts, settings, "css")
  if css then
    opt[#opt + 1] = "-c"
    opt[#opt + 1] = settings:get_css_path(opts.css_name)
  end

  local option = opts.opt or settings.opt
  opts._opt = opts._opt or {}
  option = vim.tbl_flatten({ option, opts._opt })

  for _, v in ipairs(option) do
    opt[#opt + 1] = v
  end

  uv.spawn("pandoc", { args = opt }, function(code, _)
    if code == 0 then
      print("Convertion success.")
    else
      print("Convertion failure.")
    end
  end)
end

local handle

local preview = function()
  if handle then
    return
  end
  handle = uv.spawn("live-server", {
    args = {
      "--browser=" .. output.browser,
      "-q",
      "--open=" .. output.name,
    },
    cwd = output.parent,
  }, function(code, _)
    if code ~= 0 then
      print("Server terminated abnormally.")
    end
  end)
end

local link = function()
  local image_dir = fn.expand("%:p:h") .. "/image"
  uv.fs_symlink(image_dir, output.parent .. "/image")
end

M.unlink = function()
  if output == {} then
    return
  end
  uv.fs_unlink(output.parent .. "/image")
  if output.parent == "/tmp" then
    uv.fs_unlink(output.path)
  end
end

M.run = function(opts)
  M.convert(opts)
  preview()
  link()
end

M.terminate = function()
  if handle then
    uv.process_kill(handle, 15)
    handle = nil
  end
end

-- overwrite global settings
M.setup = function(opts)
  opts = opts or {}
  for k, v in pairs(opts) do
    settings[k] = v
  end
  augroup({
    _panda_ = {
      {
        "VimLeavePre",
        "*",
        function()
          M.terminate()
          M.unlink()
        end,
      },
    },
  })
end

return M
