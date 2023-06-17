---@type LazySpec
local spec = {
  {
    "yuki-yano/vim-operator-replace",
    dependencies = "kana/vim-operator-user",
    keys = "<Plug>(operator-replace)",
    init = function()
      vim.keymap.set({ "n", "x", "o" }, "r", "<Plug>(operator-replace)")
    end,
  },
  {
    "machakann/vim-sandwich",
    keys = {
      -- Operator
      { "sa", "<Plug>(sandwich-add)", mode = { "n", "x", "o" } },
      { "sd", "<Plug>(sandwich-delete)", mode = { "n", "x" } },
      { "sdb", "<Plug>(sandwich-delete-auto)", mode = "n" },
      { "sr", "<Plug>(sandwich-replace)", mode = { "n", "x" } },
      { "srb", "<Plug>(sandwich-replace-auto)", mode = "n" },
      -- Textobject
      { "ib", "<Plug>(textobj-sandwich-auto-i)", mode = { "x", "o" } },
      { "ab", "<Plug>(textobj-sandwich-auto-a)", mode = { "x", "o" } },
      { "is", "<Plug>(textobj-query-auto-i)", mode = { "x", "o" } },
      { "as", "<Plug>(textobj-query-auto-a)", mode = { "x", "o" } },
    },
    init = function()
      vim.g.operator_sandwich_no_default_key_mappings = true
      vim.g.textobj_sandwich_no_default_key_mappings = true
    end,
    config = function()
      vim.fn["operator#sandwich#set"]("add", "char", "skip_space", 1)
    end,
  },
}

return spec
