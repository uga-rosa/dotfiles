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
    -- help in Japanese
    use({
      "vim-jp/vimdoc-ja",
      config = 'vim.o.helplang = "ja,en"',
    })
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
      setup = function()
        vim.cmd("command! ColorizerSetup lua require'colorizer'.setup()")
      end,
      cmd = "ColorizerSetup",
    })
    -- completion
    use({
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-emoji",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "saadparwaiz1/cmp_luasnip",
      },
      config = 'require("plugins.config.cmp")',
    })
    -- auto close parentheses
    use({
      "cohama/lexima.vim",
      event = "InsertEnter",
      config = 'require("plugins.config.lexima")',
    })
    -- snippet engine
    use({
      "L3MON4D3/LuaSnip",
      requires = {
        { "rafamadriz/friendly-snippets", opt = true },
      },
      config = 'require("plugins.config.luasnip")',
    })
    -- LSP
    use({
      "neovim/nvim-lspconfig",
      requires = "kabouzeid/nvim-lspinstall",
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
    -- terminal helper
    use({
      "akinsho/nvim-toggleterm.lua",
      config = 'require("plugins.config.toggleterm")',
    })
    use({
      "lewis6991/gitsigns.nvim",
      config = 'require("plugins.config.gitsigns")',
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
    -- rust
    use({
      "simrat39/rust-tools.nvim",
      ft = "rust",
      config = 'require("rust-tools").setup({})',
    })
    -- filer
    use({
      "uga-rosa/filittle.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
      },
      config = 'require("plugins.config.other").filittle()',
    })
    -- markdown preview
    use({
      "uga-rosa/panda.nvim",
      ft = "markdown",
      config = 'require("plugins.config.other").panda()',
    })
    -- SATySFi
    use({
      "qnighy/satysfi.vim",
      ft = "satysfi",
    })
  end,
})
