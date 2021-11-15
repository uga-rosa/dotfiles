if not require("plugins.packer_init") then
    return
end

local packer = require("packer")

local use = packer.use

return packer.startup({
    function()
        -- itself
        use({ "wbthomason/packer.nvim", opt = true })
        -- improve require
        use("lewis6991/impatient.nvim")
        -- improve cursorhold performance
        use("antoinemadec/FixCursorHold.nvim")
        -- colorscheme
        use("bluz71/vim-nightfly-guicolors")
        -- fast filetype.vim
        use("uga-rosa/filetype.nvim")
        -- statusline
        use({
            "famiu/feline.nvim",
            requires = "kyazdani42/nvim-web-devicons",
            config = 'require("plugins.config.feline")',
        })
        -- tab bar
        use({
            "alvarosevilla95/luatab.nvim",
            requires = "kyazdani42/nvim-web-devicons",
            config = 'require("plugins.config.other").luatab()',
        })
        -- filer
        use({
            "uga-rosa/filittle.nvim",
            requires = "kyazdani42/nvim-web-devicons",
            config = 'require("plugins.config.other").filittle()',
        })
        -- colorizer
        use("norcalli/nvim-colorizer.lua")
        -- completion
        use({
            "hrsh7th/nvim-cmp",
            requires = {
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-cmdline",
                "hrsh7th/cmp-nvim-lsp-document-symbol",
                "dcampos/cmp-snippy",
                "uga-rosa/cmp-dictionary",
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
            "dcampos/nvim-snippy",
            config = 'require("plugins.config.snippy")',
        })
        -- templete
        use({
            "mattn/vim-sonictemplate",
            config = function()
                vim.g.sonictemplate_vim_template_dir = vim.fn.stdpath("config") .. "/template"
            end,
        })
        -- LSP
        use({
            "neovim/nvim-lspconfig",
            requires = {
                "williamboman/nvim-lsp-installer",
                "tami5/lspsaga.nvim",
                "ray-x/lsp_signature.nvim",
                "folke/lua-dev.nvim",
            },
            config = 'require("plugins.config.lsp")',
        })
        -- Use neovim as a LSP
        use({
            "jose-elias-alvarez/null-ls.nvim",
            requires = {
                "nvim-lua/plenary.nvim",
                "neovim/nvim-lspconfig",
            },
            config = 'require("plugins.config.null_ls")',
        })
        -- fuzzy finder
        use({
            "nvim-telescope/telescope.nvim",
            requires = {
                "nvim-lua/plenary.nvim",
                "kyazdani42/nvim-web-devicons",
                { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
                "jvgrootveld/telescope-zoxide",
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
        -- code runner
        use({
            "michaelb/sniprun",
            requires = "rcarriga/nvim-notify",
            run = "bash ./install.sh",
            config = 'require("plugins.config.sniprun")',
        })
        -- git
        use({
            "kdheepak/lazygit.nvim",
            requires = "nvim-lua/plenary.nvim",
            config = 'require("plugins.config.other").lazygit()',
        })
        use({
            "lewis6991/gitsigns.nvim",
            requires = "nvim-lua/plenary.nvim",
            config = 'require("plugins.config.gitsigns")',
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
        -- operator replace
        use({
            "kana/vim-operator-replace",
            requires = "kana/vim-operator-user",
            keys = {
                { "n", "<Plug>(operator-replace)" },
            },
            setup = 'require("plugins.config.other").operator_replace()',
        })
        -- textobj
        use({
            "kana/vim-textobj-user",
            config = 'require("plugins.config.other").textobj()',
        })
        -- useful f, F, t and T
        use({
            "hrsh7th/vim-eft",
            config = 'require("plugins.config.other").eft()',
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
        use({
            "numToStr/Comment.nvim",
            config = 'require("Comment").setup()',
        })
        -- rust
        use({
            "simrat39/rust-tools.nvim",
            config = 'require("rust-tools").setup({})',
        })
        -- yaml
        use("pearofducks/ansible-vim")
        -- SATySFi
        use("qnighy/satysfi.vim")
        -- nim
        use({
            "uga-rosa/nim.nvim",
            config = "vim.g.nim_highlight_wait = true",
        })
        -- julia
        use("uga-rosa/julia-vim")
        -- markdown
        use("uga-rosa/vim-markdown")
        -- markdown previewer
        use({
            "iamcco/markdown-preview.nvim",
            run = "cd app && yarn install",
            config = 'require("plugins.config.other").mkdp()',
        })
        -- translate
        use({
            "uga-rosa/translate-shell.nvim",
            config = 'require("plugins.config.translate")',
        })
        -- useful functions
        use({ "uga-rosa/steelarray.nvim" })
    end,
})
