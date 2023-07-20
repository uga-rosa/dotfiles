---@type LazySpec
local spec = {
  "cohama/lexima.vim",
  event = "InsertEnter",
  config = function()
    vim.g.lexima_ctrlh_as_backspace = 1
    vim.g.lexima_disable_on_nofile = 1
    vim.g.lexima_map_escape = ""

    local my_rules = {
      {
        char = "<",
        at = [[\S\%#]],
        input_after = ">",
        filetype = "typescript",
      },
      {
        char = "<BS>",
        at = [[<\%#>]],
        input = "<BS><Del>",
      },
    }

    for _, rule in ipairs(my_rules) do
      vim.fn["lexima#add_rule"](rule)
    end

    vim.cmd("do User LazyPluginPost:lexima")
  end,
}

return spec
