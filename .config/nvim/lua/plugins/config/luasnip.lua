local luasnip = require("luasnip")

local map = myutils.map
local augroup = myutils.augroup

map({ "i", "s" }, "<C-j>", function(fallback)
  if luasnip.jumpable(1) then
    luasnip.jump(1)
  else
    fallback()
  end
end)

map({ "i", "s" }, "<C-k>", function(fallback)
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end)

map({ "i", "s" }, "<C-l>", function(fallback)
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  else
    fallback()
  end
end)

require("snippets")

require("luasnip.loaders.from_vscode").load({
  paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
})

augroup({
  luasnip_mysetting = {
    "TextChanged,InsertLeave",
    "*",
    function()
      luasnip.unlink_current_if_deleted()
    end,
  },
})

-- popup choice
local current_nsid = vim.api.nvim_create_namespace("LuaSnipChoiceListSelections")
local current_win = nil

local function window_for_choiceNode(choiceNode)
  local buf = vim.api.nvim_create_buf(false, true)
  local buf_text = {}
  local row_selection = 0
  local row_offset = 0
  for _, node in ipairs(choiceNode.choices) do
    local text = node:get_docstring()
    if node == choiceNode.active_choice then
      row_selection = #buf_text
      row_offset = #text
    end
    vim.list_extend(buf_text, text)
  end

  vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_text)
  local w, h = vim.lsp.util._make_floating_popup_size(buf_text)
  local extmark = vim.api.nvim_buf_set_extmark(
    buf,
    current_nsid,
    row_selection,
    0,
    { hl_group = "incsearch", end_line = row_selection + row_offset }
  )
  local win = vim.api.nvim_open_win(buf, false, {
    relative = "win",
    width = w,
    height = h,
    bufpos = choiceNode.mark:pos_begin_end(),
    style = "minimal",
    border = "rounded",
  })
  return { win_id = win, extmark = extmark, buf = buf }
end

_G.luasnip_popup = {}

luasnip_popup.open = function(choiceNode)
  if current_win then
    vim.api.nvim_win_close(current_win.win_id, true)
    vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
  end
  local create_win = window_for_choiceNode(choiceNode)
  current_win = {
    win_id = create_win.win_id,
    prev = current_win,
    node = choiceNode,
    extmark = create_win.extmark,
    buf = create_win.buf,
  }
end

luasnip_popup.update = function(choiceNode)
  vim.api.nvim_win_close(current_win.win_id, true)
  vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
  local create_win = window_for_choiceNode(choiceNode)
  current_win.win_id = create_win.win_id
  current_win.extmark = create_win.extmark
  current_win.buf = create_win.buf
end

luasnip_popup.close = function()
  vim.api.nvim_win_close(current_win.win_id, true)
  vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
  current_win = current_win.prev
  if current_win then
    local create_win = window_for_choiceNode(current_win.node)
    current_win.win_id = create_win.win_id
    current_win.extmark = create_win.extmark
    current_win.buf = create_win.buf
  end
end

augroup({
  choice_popup = {
    {
      "User LuasnipChoiceNodeEnter",
      function()
        luasnip_popup.open(luasnip.session.event_node)
      end,
    },
    {
      "User LuasnipChoiceNodeLeave",
      function()
        luasnip_popup.close()
      end,
    },
    {
      "User LuasnipChangeChoice",
      function()
        luasnip_popup.update(luasnip.session.event_node)
      end,
    },
  },
})
