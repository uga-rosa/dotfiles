require("config.utils")
local map = utils.map
local paq = utils.paq
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({
    "git",
    "clone",
    "--depth=1",
    "https://github.com/savq/paq-nvim.git",
    install_path,
  })
end

require("default.options")
require("default.mappings")

map("n", "<leader>ps", "<cmd>PaqSync<cr>")

paq({
  "savq/paq-nvim",
  { "vim-jp/vimdoc-ja", config = 'vim.o.helplang = "ja,en"' },
  {
    "bluz71/vim-nightfly-guicolors",
    config = function()
      vim.g.nightflyItalics = 0
      vim.cmd([[colorscheme nightfly]])
    end,
  },
  {
    "hoob3rt/lualine.nvim",
    check = "lualine",
    config = function()
      if vim.fn.has("vim_starting") == 1 then
        require("lualine").setup({
          options = { theme = "nightfly" },
        })
      end
    end,
  },
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-emoji",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",
  "saadparwaiz1/cmp_luasnip",
  "kdheepak/cmp-latex-symbols",
  { "hrsh7th/nvim-cmp", check = "cmp", config = 'require("plugins.cmp")' },
  { "cohama/lexima.vim", config = 'require("plugins.lexima")' },
  { "L3MON4D3/LuaSnip", check = "luasnip", config = 'require("plugins.luasnip")' },
  {
    "rafamadriz/friendly-snippets",
    check = "luasnip",
    config = function()
      require("luasnip.loaders.from_vscode").load({
        paths = fn.stdpath("data") .. "/site/pack/paqs/start/friendly-snippets",
      })
    end,
  },
  "kabouzeid/nvim-lspinstall",
  {
    "neovim/nvim-lspconfig",
    check = { "lspinstall", "lspconfig", "cmp_nvim_lsp" },
    config = 'require("plugins.lsp")',
  },
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "kyazdani42/nvim-web-devicons",
  {
    "nvim-telescope/telescope.nvim",
    check = "telescope",
    config = 'require("plugins.telescope")',
  },
  "nvim-treesitter/nvim-treesitter-textobjects",
  "David-Kunz/treesitter-unit",
  {
    "nvim-treesitter/nvim-treesitter",
    run = function()
      vim.cmd("TSUpdate")
    end,
    check = { "nvim-treesitter", "treesitter-unit" },
    config = 'require("plugins.treesitter")',
  },
  {
    "akinsho/nvim-toggleterm.lua",
    check = "toggleterm",
    config = 'require("plugins.toggleterm")',
  },
  { "machakann/vim-sandwich", config = 'require("plugins.sandwich")' },
  "tversteeg/registers.nvim",
  {
    "junegunn/vim-easy-align",
    config = function()
      map({ "n", "x" }, "ga", "<Plug>(EasyAlign)")
    end,
  },
  "kana/vim-operator-user",
  {
    "kana/vim-operator-replace",
    config = function()
      map("n", "_", "<Plug>(operator-replace)")
    end,
  },
  { "junegunn/fzf.vim", config = "vim.opt.rtp:append('~/.fzf')" },
  "nanotee/zoxide.vim",
  {
    "tyru/open-browser.vim",
    config = function()
      map({ "n", "x" }, "<M-o>", "<Plug>(openbrowser-smart-search)")
      vim.g.openbrowser_browser_commands = {
        { name = "chrome.exe", args = { "{browser}", "{uri}" } },
      }
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    check = "rust-tools",
    config = 'require("rust-tools").setup({})',
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.g.mkdp_refresh_slow = 1
      vim.g.mkdp_browser = "chrome.exe"
      map("n", "<leader>m", "<cmd>MarkdownPreview<cr>", "noremap")
      require("config.pasteimage")
    end,
  },
})

require("filittle").setup({
  devicons = true,
  mappings = {
    ["<cr>"] = "open",
    ["l"] = "open",
    ["<C-x>"] = "split",
    ["<C-v>"] = "vsplit",
    ["<C-t>"] = "tabedit",
    ["h"] = "up",
    ["~"] = "home",
    ["R"] = "reload",
    ["+"] = "toggle_hidden",
    ["t"] = "touch",
    ["m"] = "mkdir",
    ["d"] = "delete",
    ["r"] = "rename",
  },
})
