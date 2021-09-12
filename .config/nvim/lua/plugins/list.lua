if not require("plugins.packer_init") then
  return
end

local packer = require("packer")

local use = packer.use

return packer.startup({
  function()
    -- improve require
    use({
      "lewis6991/impatient.nvim",
      rocks = "mpack",
      config = 'pcall(require, "impatient")',
    })
    -- itself
    use({ "wbthomason/packer.nvim", opt = true })
    -- colorscheme
    use({ "bluz71/vim-nightfly-guicolors" })
    -- statusline
    use({
      "glepnir/galaxyline.nvim",
      branch = "main",
      requires = "kyazdani42/nvim-web-devicons",
      config = 'require("plugins.config.galaxyline")',
    })
    -- colorizer
    use({
      "norcalli/nvim-colorizer.lua",
      config = 'require("plugins.config.other").colorizer()',
    })
    -- completion
    use({
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
        "saadparwaiz1/cmp_luasnip",
      },
      config = 'require("plugins.config.cmp")',
    })
    -- auto close parentheses
    use({
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = 'require("plugins.config.autopairs")',
    })
    -- snippet engine
    use({
      "L3MON4D3/LuaSnip",
      config = 'require("plugins.config.luasnip")',
    })
    -- LSP
    use({
      "neovim/nvim-lspconfig",
      requires = {
        "kabouzeid/nvim-lspinstall",
        "folke/lua-dev.nvim",
        "glepnir/lspsaga.nvim",
      },
      config = 'require("plugins.config.lsp")',
    })
    -- fuzzy finder
    use({
      "ibhagwan/fzf-lua",
      requires = {
        "vijaymarupudi/nvim-fzf",
        "kyazdani42/nvim-web-devicons",
        { "junegunn/fzf", run = "./install --all" },
      },
      config = 'require("plugins.config.fzf")',
    })
    -- treesitter
    use({
      "nvim-treesitter/nvim-treesitter",
      requires = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "David-Kunz/treesitter-unit",
      },
      run = ":TSUpdate",
      config = 'require("plugins.config.treesitter")',
    })
    -- git
    use({
      "kdheepak/lazygit.nvim",
      config = function()
        utils.map("n", "<leader>l", "LazyGit", { "cmd", "noremap" })
      end,
    })
    use({
      "lewis6991/gitsigns.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = 'require("plugins.config.gitsigns")',
    })
    -- terminal
    use({
      "kassio/neoterm",
      config = 'require("plugins.config.neoterm")',
    })
    -- surround operator
    use({
      "machakann/vim-sandwich",
      config = 'require("plugins.config.sandwich")',
    })
    -- easy align
    use({
      "junegunn/vim-easy-align",
      keys = {
        { "n", "<Plug>(EasyAlign)" },
        { "x", "<Plug>(EasyAlign)" },
      },
      setup = 'require("plugins.config.other").easyalign()',
    })
    -- replace
    use({
      "kana/vim-operator-replace",
      requires = "kana/vim-operator-user",
      keys = {
        { "n", "<Plug>(operator-replace)" },
      },
      setup = 'require("plugins.config.other").operator_replace()',
    })
    -- show registers
    use("tversteeg/registers.nvim")
    -- open browser
    use({
      "tyru/open-browser.vim",
      keys = {
        { "n", "<Plug>(openbrowser-smart-search)" },
        { "x", "<Plug>(openbrowser-smart-search)" },
      },
      setup = 'require("plugins.config.other").openbrowser()',
    })
    -- filer
    use({
      "uga-rosa/filittle.nvim",
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
      config = 'require("plugins.config.other").filittle()',
    })
    -- rust
    use({
      "simrat39/rust-tools.nvim",
      ft = "rust",
      config = 'require("rust-tools").setup({})',
    })
    -- SATySFi
    use({
      "qnighy/satysfi.vim",
      ft = "satysfi",
    })
  end,
})
