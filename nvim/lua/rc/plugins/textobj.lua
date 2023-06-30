---@type LazySpec
local spec = {
  {
    "kana/vim-textobj-user",
    config = function()
      vim.fn["textobj#user#plugin"]("cmd", {
        cmd = {
          pattern = { [[\c<cmd>]], [[\c<cr>]] },
          ["select-a"] = "ac",
          ["select-i"] = "ic",
        },
      })
    end,
  },
}

return spec
