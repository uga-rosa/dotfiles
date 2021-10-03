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
    -- faster filetype.vim
    -- use({
    --   "uga-rosa/filetype.nvim",
    --   branch = "user_setting",
    --   config = 'require("plugins.config.other").filetype()',
    -- })
    -- colorscheme
    use("bluz71/vim-nightfly-guicolors")
    -- statusline
    use({
      "famiu/feline.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = 'require("plugins.config.feline")',
    })
    -- filer
    use({
      "uga-rosa/filittle.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = 'require("plugins.config.other").filittle()',
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
        "uga-rosa/cmp-dictionary",
      },
      branch = "custom-menu",
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
        "williamboman/nvim-lsp-installer",
        "glepnir/lspsaga.nvim",
        "ray-x/lsp_signature.nvim",
      },
      config = 'require("plugins.config.lsp")',
    })
    -- fuzzy finder
    use({
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      },
      config = 'require("plugins.config.telescope")',
    })
    -- treesitter
    use({
      "nvim-treesitter/nvim-treesitter",
      requires = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "p00f/nvim-ts-rainbow",
        "David-Kunz/treesitter-unit",
      },
      run = ":TSUpdate",
      config = 'require("plugins.config.treesitter")',
    })
    -- git
    use({
      "TimUntersberger/neogit",
      key = "Neogit",
      requires = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
      },
      setup = 'require("plugins.config.neogit").setup()',
      config = 'require("plugins.config.neogit").config()',
    })
    use({
      "lewis6991/gitsigns.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = 'require("plugins.config.gitsigns")',
    })
    -- quickrun
    use({
      "thinca/vim-quickrun",
      requires = "lambdalisue/vim-quickrun-neovim-job",
      config = 'require("plugins.config.quickrun")',
    })
    -- surround operator
    use({
      "machakann/vim-sandwich",
      config = 'require("plugins.config.other").sandwich()',
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
    -- comment out
    use("tpope/vim-commentary")
    -- rust
    use({
      "simrat39/rust-tools.nvim",
      ft = "rust",
      config = 'require("rust-tools").setup({})',
    })
    -- yaml
    use({
      "pearofducks/ansible-vim",
      ft = "yaml.ansible",
    })
    -- SATySFi
    use({
      "qnighy/satysfi.vim",
      ft = "satysfi",
    })
    -- nim
    use({
      "uga-rosa/nim.nvim",
      config = "vim.g.nim_highlight_wait = true",
    })
  end,
})
