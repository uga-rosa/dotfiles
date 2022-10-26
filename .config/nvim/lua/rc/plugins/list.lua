local fn = vim.fn

local ok = pcall(require, "packer")

if not ok then
    local packer_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
    fn.delete(packer_path, "rf")
    fn.system({
        "git",
        "clone",
        "https://github.com/wbthomason/packer.nvim",
        packer_path,
    })
end

vim.cmd([[packadd packer.nvim]])
local packer = require("packer")
local use = packer.use

packer.init({
    display = {
        open_fn = require("packer.util").float,
    },
    git = {
        clone_timeout = 600,
    },
    compile_path = vim.fn.stdpath("config") .. "/lua/rc/packer_compiled.lua",
})

return packer.startup({
    function()
        -- itself
        use({ "wbthomason/packer.nvim", opt = true })

        -- improved require()
        use("lewis6991/impatient.nvim")

        -- library
        use({
            "nvim-lua/plenary.nvim",
            config = 'require("rc.plugins.config.plenary")',
        })
        use("kyazdani42/nvim-web-devicons")
        use("tami5/sqlite.lua")
        use("~/plugin/lua-utils.nvim")
        use("Shougo/pum.vim")

        -- colorscheme
        use({
            "bluz71/vim-nightfly-guicolors",
            config = 'require("rc.plugins.config.vim-nightfly-guicolors")',
        })

        -- status line
        use({
            "feline-nvim/feline.nvim",
            requires = "nvim-web-devicons",
            event = { "BufRead", "BufNewFile" },
            setup = 'require("rc.plugins.setup.feline")',
            config = 'require("rc.plugins.config.feline")',
        })

        -- completion
        use({
            "hrsh7th/nvim-cmp",
            after = "LuaSnip",
            event = { "InsertEnter", "CmdlineEnter" },
            config = 'require("rc.plugins.config.nvim-cmp")',
        })

        -- cmp's sources
        use({
            "hrsh7th/cmp-buffer",
            after = "nvim-cmp",
        })

        use({
            "hrsh7th/cmp-path",
            after = "nvim-cmp",
        })

        use({
            "hrsh7th/cmp-nvim-lsp",
            after = "nvim-cmp",
        })

        use({
            "hrsh7th/cmp-nvim-lua",
            after = "nvim-cmp",
        })

        use({
            "hrsh7th/cmp-nvim-lsp-signature-help",
            after = "nvim-cmp",
        })

        use({
            "hrsh7th/cmp-emoji",
            after = "nvim-cmp",
        })

        use({
            "hrsh7th/cmp-cmdline",
            after = "nvim-cmp",
        })

        use({
            "saadparwaiz1/cmp_luasnip",
            after = "nvim-cmp",
        })

        use({
            "~/plugin/cmp-dictionary",
            after = "nvim-cmp",
            config = 'require("rc.plugins.config.cmp-dictionary")',
        })

        use({
            "~/plugin/cmp-latex-symbol",
            after = "nvim-cmp",
        })

        use({
            "~/plugin/cmp-dynamic",
            after = "nvim-cmp",
            config = 'require("rc.plugins.config.cmp-dynamic")',
        })

        -- snippet engine
        use({
            "L3MON4D3/LuaSnip",
            event = "InsertEnter",
            config = 'require("rc.plugins.config.LuaSnip")',
        })

        -- autopairs
        use({
            "cohama/lexima.vim",
            event = "InsertEnter",
            config = 'require("rc.plugins.config.lexima")',
        })

        -- surround
        use({
            "machakann/vim-sandwich",
            setup = 'require("rc.plugins.setup.vim-sandwich")',
            config = 'require("rc.plugins.config.vim-sandwich")',
        })

        -- fuzzy finder
        use({
            "nvim-telescope/telescope.nvim",
            requires = {
                "plenary.nvim",
                "nvim-web-devicons",
                "telescope-fzf-native.nvim",
                "telescope-frecency.nvim",
                "nvim-telescope/telescope-ui-select.nvim",
            },
            setup = 'require("rc.plugins.setup.telescope")',
            config = 'require("rc.plugins.config.telescope")',
        })

        use({
            "nvim-telescope/telescope-fzf-native.nvim",
            run = "make",
        })
        use({
            "nvim-telescope/telescope-frecency.nvim",
            requires = "tami5/sqlite.lua",
        })

        use({
            "nvim-telescope/telescope-ui-select.nvim",
        })

        -- LSP configuration
        use("neovim/nvim-lspconfig")

        -- easily install and manage LSP servers, DAP servers, linters, and formatters.
        use({
            "williamboman/mason.nvim",
            config = 'require("rc.plugins.config.mason")',
        })
        use({
            "williamboman/mason-lspconfig.nvim",
            after = {
                "nvim-lspconfig",
                "mason.nvim",
                "cmp-nvim-lsp",
                "lspsaga.nvim",
            },
            event = "BufEnter",
            config = 'require("rc.plugins.config.mason-lspconfig")',
        })

        -- utilities for nvim-lsp
        use({
            "glepnir/lspsaga.nvim",
            branch = "main",
            requires = "nvim-lspconfig",
            config = 'require("rc.plugins.config.lspsaga")',
        })

        -- UI for nvim-lsp progress
        use({
            "j-hui/fidget.nvim",
            config = 'require("fidget").setup({})',
        })

        -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
        use({
            "jose-elias-alvarez/null-ls.nvim",
            config = 'require("rc.plugins.config.null-ls")',
        })

        -- tree-sitter
        use({
            "nvim-treesitter/nvim-treesitter",
            requires = { "nvim-treesitter-textobjects", "nvim-ts-rainbow", "treesitter-unit" },
            run = ":TSUpdate",
            config = 'require("rc.plugins.config.nvim-treesitter")',
        })

        use("nvim-treesitter/nvim-treesitter-textobjects")
        use("p00f/nvim-ts-rainbow")
        use({
            "David-Kunz/treesitter-unit",
            config = 'require("rc.plugins.config.treesitter-unit")',
        })

        use({
            "nvim-treesitter/playground",
            after = "nvim-treesitter",
        })

        -- filer
        use({
            "kyazdani42/nvim-tree.lua",
            requires = "nvim-web-devicons",
            config = 'require("rc.plugins.config.nvim-tree")',
        })

        -- git
        use({
            "kdheepak/lazygit.nvim",
            config = 'require("rc.plugins.config.lazygit")',
        })

        use({
            "lewis6991/gitsigns.nvim",
            config = 'require("rc.plugins.config.gitsigns")',
        })

        -- general task runner
        use({
            "thinca/vim-quickrun",
            requires = "vim-quickrun-neovim-job",
            setup = 'require("rc.plugins.setup.vim-quickrun")',
        })
        use("lambdalisue/vim-quickrun-neovim-job")

        -- operator
        use("kana/vim-operator-user")
        use({
            "kana/vim-operator-replace",
            requires = "vim-operator-user",
            keys = "<Plug>(operator-replace)",
            setup = [[vim.cmd("nmap r <Plug>(operator-replace)")]],
        })

        -- utilities for search
        use({
            "hrsh7th/vim-searchx",
            event = { "BufRead", "BufNewFile" },
            setup = 'require("rc.plugins.setup.searchx")',
        })

        -- jump to anywhere!
        use({
            "rlane/pounce.nvim",
            event = "BufEnter",
            config = 'require("rc.plugins.config.pounce")',
        })

        -- open browser
        use({
            "tyru/open-browser.vim",
            event = { "BufRead", "BufNewFile" },
            setup = 'require("rc.plugins.setup.open-browser")',
        })

        -- change window
        use("simeji/winresizer")

        -- comment out
        use("tpope/vim-commentary")

        -- translate
        use({
            "~/plugin/translate.nvim",
            event = { "BufRead", "BufNewFile" },
            config = 'require("rc.plugins.config.translate")',
        })

        -- markdown previewer
        use({
            "previm/previm",
            ft = "markdown",
            config = 'require("rc.plugins.config.previm")',
        })

        -- utilities for markdown table
        use({
            "mattn/vim-maketable",
            ft = "markdown",
        })

        -- color picker
        use({
            "~/plugin/ccc.nvim",
            config = 'require("rc.plugins.config.ccc")',
        })

        -- add sub cursor
        use({
            "gen740/SmoothCursor.nvim",
            config = 'require("rc.plugins.config.SmoothCursor")',
        })

        use({
            "junegunn/vim-easy-align",
            map = "<Plug>(EasyAlign)",
            setup = function()
                vim.keymap.set({ "n", "x" }, "ga", "<Plug>(EasyAlign)", {})
            end,
        })

        -- python
        use({
            "~/plugin/vim-gindent",
            config = 'require("rc.plugins.config.gindent")',
        })

        -- nim
        use("alaviss/nim.nvim")

        use("~/plugin/todo.nvim")
        use("~/plugin/join.nvim")

        -- IME
        use({
            "~/plugin/jam.nvim",
            config = 'require("rc.plugins.config.jam")',
        })

        use("~/plugin/nvim-kit")

        use({
            "~/plugin/linkformat.vim",
            config = 'require("rc.plugins.config.linkformat")',
        })

        use("thinca/vim-partedit")
    end,
})
