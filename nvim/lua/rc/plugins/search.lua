---@type PluginSpec
local spec = {
  {
    "hrsh7th/vim-searchx",
    keys = {
      { "/", "<Cmd>call searchx#start(#{dir: 1})<CR>", mode = { "n", "x" } },
      { "?", "<Cmd>call searchx#start(#{dir: 0})<CR>", mode = { "n", "x" } },
      { "n", "<Cmd>call searchx#next()<CR>", mode = { "n", "x" } },
      { "N", "<Cmd>call searchx#prev()<CR>", mode = { "n", "x" } },
      { "/", "<Cmd>call searchx#start(#{dir: 1})<CR>", mode = { "n", "x" } },
      { "<M-/>", "<Cmd>call rc#kensaku#start(1)<CR>", mode = { "n", "x" } },
      { "<M-?>", "<Cmd>call rc#kensaku#start(0)<CR>", mode = { "n", "x" } },
    },
    init = function()
      vim.g.searchx = {
        auto_accept = true,
        ---@diagnostic disable-next-line
        scrolloff = vim.opt.scrolloff:get(),
        scrolltime = 0,
        nohlsearch = {
          jump = true,
        },
        markers = vim.split("ASDFGHJKL:QWERTYUIOP", ""),
      }
    end,
  },
  {
    "yuki-yano/fuzzy-motion.vim",
    dependencies = {
      "denops.vim",
      "kensaku.vim",
    },
    init = function()
      vim.g.fuzzy_motion_matchers = { "fzf", "kensaku" }
      vim.keymap.set("n", "ss", "<Cmd>FuzzyMotion<CR>")
    end,
  },
  {
    "lambdalisue/kensaku.vim",
    name = "kensaku.vim",
    dependencies = "denops.vim",
    config = function()
      local config_dir = vim.fn.stdpath("config") --[[@as string]]
      local path = vim.fs.joinpath(config_dir, "script", "azik", "skkeleton.json")
      local romanTableJson = vim.fs.read(path)
      local romanTableObj = vim.json.decode(romanTableJson)
      local romanTable = {}
      for key, value in pairs(romanTableObj) do
        table.insert(romanTable, { key, value[1], 0 })
      end
      vim.fn["kensaku#set_roman_table"](romanTable)
    end,
  },
}

return spec
