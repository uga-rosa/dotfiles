---@type PluginSpec
local spec = {
  "lewis6991/gitsigns.nvim",
  config = function()
    local gs = require("gitsigns")
    gs.setup({
      on_attach = function(bufnr)
        local function map(mode, l, r, opts)
          opts = vim.F.if_nil(opts, {})
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        -- Navigates
        map("n", "]g", function()
          if vim.wo.diff then
            return "]g"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })
        map("n", "[g", function()
          if vim.wo.diff then
            return "[g"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })
        -- Actions
        map({ "n", "v" }, "<Space>gs", ":Gitsigns stage_hunk<CR>")
        map({ "n", "v" }, "<Space>gu", ":Gitsigns undo_stage_hunk<CR>")
        map({ "n", "v" }, "<Space>gr", ":Gitsigns reset_hunk<CR>")
        -- Text object
        map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    })
  end,
}

return spec
