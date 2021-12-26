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
                "hrsh7th/cmp-nvim-lua",
                "hrsh7th/cmp-cmdline",
                "hrsh7th/cmp-nvim-lsp-document-symbol",
                "hrsh7th/cmp-nvim-lsp-signature-help",
                "saadparwaiz1/cmp_luasnip",
                -- "uga-rosa/cmp-dictionary",
            },
            config = 'require("plugins.config.cmp")',
        })
        -- auto close parentheses
        use({
            "windwp/nvim-autopairs",
            config = 'require("plugins.config.autopairs")',
        })
        -- snippet engine
        use({
            "L3MON4D3/LuaSnip",
            config = 'require("plugins.config.luasnip")',
            -- branch = "better_argnodes",
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
            "ibhagwan/fzf-lua",
            requires = {
                "vijaymarupudi/nvim-fzf",
                "kyazdani42/nvim-web-devicons",
            },
            config = 'require("plugins.config.fzf")',
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
            "thinca/vim-quickrun",
            requires = "lambdalisue/vim-quickrun-neovim-job",
            config = 'require("plugins.config.quickrun")',
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
        -- markdown previewer
        use({
            "iamcco/markdown-preview.nvim",
            run = "cd app && yarn install",
            config = 'require("plugins.config.other").mkdp()',
        })
        -- translate
        use({
            "uga-rosa/translate-shell.nvim",
            config = 'require("plugins.config.other").translate()',
        })
        -- useful functions
        use({ "uga-rosa/steelarray.nvim" })
        -- util search
        use({
            "VonHeikemen/searchbox.nvim",
            requires = "MunifTanjim/nui.nvim",
            config = 'require("plugins.config.other").search()',
        })
        -- quickfix
        use({ "thinca/vim-qfreplace" })
    end,
})
