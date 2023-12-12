local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "uga-rosa/denippet.vim",
  dev = true,
  dependencies = {
    "denops.vim",
    "ddc.vim",
  },
  config = function()
    -- loader
    local root = vim.fn.stdpath("config") .. "/snippets/"
    for name, _ in vim.fs.dir(root) do
      vim.fn["denippet#load"](root .. name)
    end

    vim.g.denippet_drop_on_zero = true

    -- mapping
    vim.keymap.set("i", "<C-l>", "<Plug>(denippet-expand)")
    vim.keymap.set(
      { "i", "s" },
      "<Tab>",
      "denippet#jumpable() ? '<Plug>(denippet-jump-next)' : '<Tab>'",
      { expr = true, replace_keycodes = false }
    )
    vim.keymap.set(
      { "i", "s" },
      "<S-Tab>",
      "denippet#jumpable(-1) ? '<Plug>(denippet-jump-prev)' : '<S-Tab>'",
      { expr = true, replace_keycodes = false }
    )
    vim.keymap.set("i", "<C-n>", function()
      if vim.fn["denippet#choosable"]() then
        vim.fn["denippet#choice"](1)
      else
        vim.fn["pum#map#insert_relative"](1, "loop")
      end
    end)
    vim.keymap.set("i", "<C-p>", function()
      if vim.fn["denippet#choosable"]() then
        vim.fn["denippet#choice"](-1)
      else
        vim.fn["pum#map#insert_relative"](-1, "loop")
      end
    end)

    -- ddc-source-denippet
    helper.patch_global({
      sourceOptions = {
        denippet = {
          mark = "[Denippet]",
          keywordPattern = [=[\k+|[^[:keyword:]]+]=],
        },
      },
    })

    -- popup for choice
    local Popup = {}

    function Popup.new()
      return setmetatable({
        nsid = vim.api.nvim_create_namespace("denippet_choice_popup"),
      }, { __index = Popup })
    end

    function Popup:open(node)
      self.buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_text(self.buf, 0, 0, 0, 0, node.items)
      local w, h = vim.lsp.util._make_floating_popup_size(node.items, {})
      self.win = vim.api.nvim_open_win(self.buf, false, {
        relative = "win",
        width = w,
        height = h,
        bufpos = { node.range.start.line, node.range.start.character },
        style = "minimal",
        border = "single",
      })
      self.extmark = vim.api.nvim_buf_set_extmark(
        self.buf,
        self.nsid,
        node.index,
        0,
        { hl_group = "incsearch", end_line = node.index + 1 }
      )
    end

    function Popup:update()
      vim.api.nvim_buf_del_extmark(self.buf, self.nsid, self.extmark)
      local node = vim.b.denippet_current_node
      self.extmark = vim.api.nvim_buf_set_extmark(
        self.buf,
        self.nsid,
        node.index,
        0,
        { hl_group = "incsearch", end_line = node.index + 1 }
      )
    end

    function Popup:close()
      if self.win then
        vim.api.nvim_win_close(self.win, true)
        self.buf = nil
        self.win = nil
        self.extmark = nil
      end
    end

    local popup = Popup.new()

    local group = vim.api.nvim_create_augroup("denippet_choice_popup", {})
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "DenippetNodeEnter",
      callback = function()
        local node = vim.b.denippet_current_node
        if node and node.type == "choice" then
          vim.fn["ddc#custom#patch_global"]("ui", "none")
          popup:open(node)
        end
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "DenippetChoiceSelected",
      callback = function()
        popup:update()
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "DenippetNodeLeave",
      callback = function()
        popup:close()
        vim.fn["ddc#custom#patch_global"]("ui", "pum")
      end,
    })
  end,
}

return spec
