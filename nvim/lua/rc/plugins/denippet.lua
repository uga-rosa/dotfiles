local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "uga-rosa/denippet.nvim",
  dev = true,
  -- enabled = false,
  dependencies = {
    "denops.vim",
    "ddc.vim",
  },
  config = function()
    -- loader
    local root = vim.fn.stdpath("config") .. "/snippets/"
    for name, _ in vim.fs.dir(root) do
      if not vim.endswith(name, ".snippets") then
        vim.fn["denippet#load"](root .. name)
      end
    end

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

    -- ddc-source-denippet
    helper.patch_global({
      sourceOptions = {
        denippet = {
          mark = "[Denippet]",
          keywordPattern = [=[\k+|[^[:keyword:]]+]=],
        },
      },
    })
  end,
}

return spec
