-- Yank to OS clipboard via OSC52

---@enum (key) mode
local commands = {
  block = "`[`]y",
  char = "`[v`]y",
  line = "`[V`]y",
}

---@param command string
---@return string
local function get_text(command)
  local clipboard = vim.api.nvim_get_option_value("clipboard", {})
  local selection = vim.api.nvim_get_option_value("selection", {})
  local register = vim.fn.getreg('"')
  local visual_marks = { vim.fn.getpos("'<"), vim.fn.getpos("'>") }

  -- Retrieve text
  vim.api.nvim_set_option_value("clipboard", "", {})
  vim.api.nvim_set_option_value("selection", "inclusive", {})
  vim.cmd.normal({ args = { command }, bang = true, mods = { keepjumps = true } })
  local text = vim.fn.getreg('"') --[[@as string]]

  -- Restore user settings
  vim.api.nvim_set_option_value("clipboard", clipboard, {})
  vim.api.nvim_set_option_value("selection", selection, {})
  vim.fn.setreg('"', register)
  vim.fn.setpos("'<", visual_marks[1])
  vim.fn.setpos("'>", visual_marks[2])

  return text
end

local osc52_format = "\x1b]52;c;%s\a"

---@param text string
---@return string
local function osc52(text)
  return osc52_format:format(vim.base64.encode(text))
end

---@param mode mode
function _G.oscyank_operator(mode)
  local text = get_text(commands[mode])
  -- 2 is v:stderr
  vim.api.nvim_chan_send(2, osc52(text))
end

vim.keymap.set("n", "<Space>c", function()
  vim.opt.operatorfunc = "v:lua.oscyank_operator"
  return "g@"
end, { expr = true })

vim.keymap.set("n", "<Space>cc", "<Space>c_", { remap = true })

vim.keymap.set("x", "<CR>", function()
  vim.cmd(vim.keycode("normal! <Esc>"))
  local text = get_text("gvy")
  vim.api.nvim_chan_send(2, osc52(text))
end)
