---@class Window
local Window = {}

---@param opt table
---@return Window
--- opt.pos: position
--- opt.split: sp or vs
--- opt.width: width
--- opt.height: height
function Window:new(opt)
  opt = opt or {}
  self.pos = opt.pos or "botright"
  self.split = opt.split or "sp"
  self.width = opt.width
  self.height = opt.height
  return self
end

---Create new window.
---@param bufnr integer
---@return integer
function Window:create(bufnr)
  local cmd = "%s %s %d"
  vim.cmd(cmd:format(self.pos, self.split, bufnr))

  self.winid = vim.fn.win_getid()
  self:update_size()

  return self.winid
end

---Update the size of the window.
---@return nil
function Window:update_size()
  if self.width then
    vim.api.nvim_win_set_width(self.winid, self.width)
  end
  if self.height then
    vim.api.nvim_win_set_height(self.winid, self.height)
  end
end

---Returns window size (width, height)
---@return integer
---@return integer
function Window:get_size()
  return vim.api.nvim_win_get_width(self.winid), vim.api.nvim_win_get_height(self.winid)
end

---Change the size of the window.
---dir == 1 mean height, dir == -1 mean width
---@param dir integer
---@param by integer
---@return nil

function Window:size_change(dir, by)
  local width, height = self:get_size()
  if dir == 1 then
    self.height = height + by
    self:update_size()
  elseif dir == -1 then
    self.width = width + by
    self:update_size()
  end
end

return Window
