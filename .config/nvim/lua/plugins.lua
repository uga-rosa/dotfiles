if not require("packerInit") then
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
      config = 'require("plugins.cmp")',
      requires = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-emoji",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "saadparwaiz1/cmp_luasnip",
        "kdheepak/cmp-latex-symbols",
      },
    })
    use({
      "cohama/lexima.vim",
      event = "InsertEnter",
      config = 'require("plugins.lexima")',
    })
    use({
      "L3MON4D3/LuaSnip",
      config = 'require("plugins.luasnip")',
      requires = "rafamadriz/friendly-snippets",
    })
    use("kabouzeid/nvim-lspinstall")
    use({
      "neovim/nvim-lspconfig",
      config = 'require("plugins.lsp")',
    })
    use("nvim-lua/popup.nvim")
    use("nvim-lua/plenary.nvim")
    use("kyazdani42/nvim-web-devicons")
    use({
      "nvim-telescope/telescope.nvim",
      config = 'require("plugins.telescope")',
    })
    use("nvim-treesitter/nvim-treesitter-textobjects")
    use("David-Kunz/treesitter-unit")
    use({
      "nvim-treesitter/nvim-treesitter",
      run = "TSUpdate",
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
    use("kana/vim-operator-user")
    use({
      "kana/vim-operator-replace",
      config = 'require("plugins.other").operator_replace()',
    })
    use({
      "junegunn/fzf.vim",
      requires = { "junegunn/fzf", run = "./install --all" },
    })
    use("nanotee/zoxide.vim")
    use({
      "tyru/open-browser.vim",
      config = 'require("plugins.other").openbrowser()',
    })
    use({
      "simrat39/rust-tools.nvim",
      ft = "rust",
      config = 'require("rust-tools").setup({})',
    })
  end,
})

--require("filittle").setup({
--  devicons = true,
--  mappings = {
--    ["<cr>"] = "open",
--    ["l"] = "open",
--    ["<C-x>"] = "split",
--    ["<C-v>"] = "vsplit",
--    ["<C-t>"] = "tabedit",
--    ["h"] = "up",
--    ["~"] = "home",
--    ["R"] = "reload",
--    ["+"] = "toggle_hidden",
--    ["t"] = "touch",
--    ["m"] = "mkdir",
--    ["d"] = "delete",
--    ["r"] = "rename",
--  },
--})
