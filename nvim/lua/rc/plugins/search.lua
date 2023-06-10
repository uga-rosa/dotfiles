---@type LazySpec
local spec = {
  {
    "hrsh7th/vim-searchx",
    dependencies = "lambdalisue/kensaku.vim",
    keys = {
      { "/", "<Cmd>call searchx#start(#{dir: 1})<CR>", mode = { "n", "x" } },
      { "?", "<Cmd>call searchx#start(#{dir: 0})<CR>", mode = { "n", "x" } },
      { "n", "<Cmd>call searchx#next()<CR>", mode = { "n", "x" } },
      { "N", "<Cmd>call searchx#prev()<CR>", mode = { "n", "x" } },
      { "/", "<Cmd>call searchx#start(#{dir: 1})<CR>", mode = { "n", "x" } },
      { "<M-/>", "<Cmd>call vimrc#kensaku#start(1)<CR>", mode = { "n", "x" } },
      { "<M-?>", "<Cmd>call vimrc#kensaku#start(0)<CR>", mode = { "n", "x" } },
    },
    init = function()
      vim.g.searchx = {
        auto_accept = true,
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
      "vim-denops/denops.vim",
      "lambdalisue/kensaku.vim",
    },
    init = function()
      vim.g.fuzzy_motion_matchers = { "fzf", "kensaku" }
      vim.keymap.set("n", "ss", "<Cmd>FuzzyMotion<CR>")
    end,
  },
  {
    "lambdalisue/kensaku.vim",
    dependencies = "vim-denops/denops.vim",
    config = function()
      local romanTableJson = vim.fs.read(vim.fn.stdpath("config") .. "/script/azik.json")
      local romanTableObj = vim.json.decode(romanTableJson)
      local romanTable = {}
      for key, value in pairs(romanTableObj) do
        table.insert(romanTable, { key, value[1], 0 })
      end
      vim.af.kensaku.set_roman_table(romanTable)
    end,
  },
}

return spec
