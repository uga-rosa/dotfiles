if not require("packer_init") then
  return
end

local packer = require("packer")

local use = packer.use

return packer.startup({
  function()
    use({ "wbthomason/packer.nvim", opt = true })
    use({
      "vim-jp/vimdoc-ja",
      config = 'vim.o.helplang = "ja,en"',
    })
    use({ "bluz71/vim-nightfly-guicolors" })
    use({
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-emoji",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "saadparwaiz1/cmp_luasnip",
        "kdheepak/cmp-latex-symbols",
      },
      config = 'require("plugins.cmp")',
    })
    use({
      "cohama/lexima.vim",
      event = "InsertEnter",
      config = 'require("plugins.lexima")',
    })
    use({
      "L3MON4D3/LuaSnip",
      requires = "rafamadriz/friendly-snippets",
      config = 'require("plugins.luasnip")',
    })
    use({
      "neovim/nvim-lspconfig",
      requires = "kabouzeid/nvim-lspinstall",
      config = 'require("plugins.lsp")',
    })
    use({
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
      },
      config = 'require("plugins.telescope")',
    })
    use({
      "nvim-treesitter/nvim-treesitter",
      requires = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "David-Kunz/treesitter-unit",
      },
      run = ":TSUpdate",
      config = 'require("plugins.treesitter")',
    })
    use({
      "akinsho/nvim-toggleterm.lua",
      config = 'require("plugins.toggleterm")',
    })
    use({
      "machakann/vim-sandwich",
      config = 'require("plugins.sandwich")',
    })
    use("tversteeg/registers.nvim")
    use({
      "junegunn/vim-easy-align",
      config = 'require("plugins.other").easyalign()',
    })
    use({
      "kana/vim-operator-replace",
      requires = "kana/vim-operator-user",
      config = 'require("plugins.other").operator_replace()',
    })
    use({
      "nanotee/zoxide.vim",
      requires = {
        { "junegunn/fzf", run = "./install --all" },
        "junegunn/fzf.vim",
      },
    })
    use({
      "tyru/open-browser.vim",
      config = 'require("plugins.other").openbrowser()',
    })
    use({
      "simrat39/rust-tools.nvim",
      ft = "rust",
      config = 'require("rust-tools").setup({})',
    })
    use({
      "uga-rosa/filittle.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
      },
      config = 'require("plugins.other").filittle()',
    })
  end,
})
