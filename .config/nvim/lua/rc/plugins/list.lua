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

        -- improve require
        use("lewis6991/impatient.nvim")

        -- requires
        use("nvim-lua/plenary.nvim")
        use("kyazdani42/nvim-web-devicons")
        use({
            "vim-denops/denops.vim",
            event = "CursorHold",
            config = 'require("rc.plugins.config.denops-vim")',
        })

        -- colorscheme
        use({
            "bluz71/vim-nightfly-guicolors",
            event = "VimEnter",
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

        -- snippet engine
        use({
            "L3MON4D3/LuaSnip",
            event = "InsertEnter",
            config = 'require("rc.plugins.config.LuaSnip")',
        })

        -- autopairs
        use({
            "windwp/nvim-autopairs",
            requires = "nvim-cmp",
            event = "InsertEnter",
            config = 'require("rc.plugins.config.nvim-autopairs")',
        })

        -- surround
        use({
            "machakann/vim-sandwich",
            event = "BufEnter",
            setup = 'require("rc.plugins.setup.vim-sandwich")',
            config = 'require("rc.plugins.config.vim-sandwich")',
        })

        -- fuzzy finder
        use({
            "nvim-telescope/telescope.nvim",
            requires = { "plenary.nvim", "nvim-web-devicons", "telescope-fzf-native.nvim" },
            event = "VimEnter",
            setup = 'require("rc.plugins.setup.telescope")',
            config = 'require("rc.plugins.config.telescope")',
        })

        use({
            "nvim-telescope/telescope-fzf-native.nvim",
            run = "make",
        })

        -- LSP configuration
        use("neovim/nvim-lspconfig")

        -- easily install and manage LSP servers, DAP servers, linters, and formatters.
        use({
            "williamboman/mason.nvim",
            event = "VimEnter",
            config = 'require("rc.plugins.config.mason")',
        })
        use({
            "williamboman/mason-lspconfig.nvim",
            after = { "nvim-lspconfig", "mason.nvim", "cmp-nvim-lsp", "lspsaga.nvim" },
            ft = { "lua", "vim", "go", "nim", "sh", "python" },
            config = 'require("rc.plugins.config.mason-lspconfig")',
        })

        -- utilities for nvim-lsp
        use({
            "glepnir/lspsaga.nvim",
            requires = "nvim-lspconfig",
            config = 'require("rc.plugins.config.lspsaga")',
        })

        -- UI for nvim-lsp progress
        use({
            "j-hui/fidget.nvim",
            config = 'require("fidget").setup({})',
        })

        use({
            "uga-rosa/lua-dev.nvim",
            config = 'require("rc.plugins.config.lua-dev")',
        })

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
            event = "BufEnter",
            config = 'require("rc.plugins.config.nvim-tree")',
        })

        -- git
        use({
            "lambdalisue/gina.vim",
            event = "BufEnter",
            setup = 'require("rc.plugins.setup.gina")',
            config = 'require("rc.plugins.config.gina")',
        })

        -- markdown previewer
        use({
            "tani/glance-vim",
            requires = "denops.vim",
            ft = "markdown",
            config = 'require("rc.plugins.config.glance-vim")',
        })

        -- utilities for markdown table
        use({
            "mattn/vim-maketable",
            ft = "markdown",
        })

        -- general task runner
        use({
            "thinca/vim-quickrun",
            requires = "vim-quickrun-neovim-job",
            event = "BufEnter",
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
            event = "BufRead",
            setup = 'require("rc.plugins.setup.searchx")',
        })

        -- jump to anywhere!
        use({
            "yuki-yano/fuzzy-motion.vim",
            requires = "denops.vim",
            event = "BufRead",
            setup = 'require("rc.plugins.setup.fuzzy-motion")',
        })

        -- open browser
        use({
            "tyru/open-browser.vim",
            event = "BufRead",
            setup = 'require("rc.plugins.setup.open-browser")',
        })

        -- change window
        use({
            "simeji/winresizer",
            event = "BufEnter",
        })

        -- comment out
        use("tpope/vim-commentary")

        -- nim
        use({
            "alaviss/nim.nvim",
            ft = "nim",
        })

        -- translate
        use({
            "~/plugin/translate.nvim",
            event = "BufRead",
            config = 'require("rc.plugins.config.translate")',
        })

        -- japanese help
        use({
            "vim-jp/vimdoc-ja",
            config = function()
                vim.opt.helplang = "ja,en"
            end,
        })

        -- reference for Lua
        use("milisims/nvim-luaref")

        -- reference for luv (vim.loop)
        use("nanotee/luv-vimdocs")
    end,
})
