local M = {}

local key = require("deepl.key")
local json = require("deepl.json")
local a = vim.api
local f = vim.fn

local current_win

function M.close()
  if current_win then
    a.nvim_win_close(current_win.win, true)
    current_win = nil
  end
end

function M.create_window(lines, width, row, col)
  M.close()
  local buf = a.nvim_create_buf(false, true)
  a.nvim_buf_set_lines(buf, 0, -1, true, lines)
  local win = a.nvim_open_win(buf, false, {
    relative = "win",
    width = width,
    height = #lines,
    style = "minimal",
    row = row,
    col = col,
    border = "single",
  })
  return { win = win, buf = buf }
end

function M.translate(line1, line2, from, to, mode)
  local texts = a.nvim_buf_get_lines(0, line1 - 1, line2, true)
  local txt = table.concat(texts, " "):gsub("%s+", " ")

  local args = {
    "https://api-free.deepl.com/v2/translate",
    "-s",
    "-d",
    "auth_key=" .. key,
    "-d",
    '"text=' .. txt .. '"',
    "-d",
    '"source_lang=' .. from .. '"',
    "-d",
    '"target_lang=' .. to .. '"',
  }
  local cmd = "curl " .. table.concat(args, " ")

  local file = io.popen(cmd, "r")
  local text = json.decode(file:read("*a")).translations[1].text
  file:close()

  if mode == "r" then
    a.nvim_buf_set_lines(0, line1 - 1, line2, true, { text })
    return
  elseif mode ~= "f" then
    return
  end

  local lines = {}
  local width = math.floor(a.nvim_win_get_width(0) * 0.8)
  if width % 2 == 1 then
    width = width - 1
  end
  if to == "JA" then
    local _width = width / 2
    local col = math.floor(f.strchars(text) / _width) + 1
    for i = 1, col do
      lines[i] = f.strcharpart(text, _width * (i - 1), _width)
    end
  else
    local col = math.floor(#text / width) + 1
    for i = 1, col do
      lines[i] = text:sub(1 + width * (i - 1), width * i)
    end
  end
  local row = 2
  local col = math.floor(a.nvim_win_get_width(0) * 0.1)
  current_win = M.create_window(lines, width, row, col)
end

function M.setup()
  vim.cmd([[
  command! -range TransJA2ENf lua require("deepl").translate(<line1>, <line2>, "JA", "EN", "f")
  command! -range TransEN2JAf lua require("deepl").translate(<line1>, <line2>, "EN", "JA", "f")
  command! -range TransJA2ENr lua require("deepl").translate(<line1>, <line2>, "JA", "EN", "r")
  command! -range TransEN2JAr lua require("deepl").translate(<line1>, <line2>, "EN", "JA", "r")
  command! TransClose lua require("deepl").close()
  ]])
end

return M
