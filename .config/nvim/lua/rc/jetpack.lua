-- local plugin_root = vim.fn.stdpath("data") .. "/site/pack/jetpack"
-- local jetpack_path = plugin_root .. "/opt/vim-jetpack"
-- if not vim.bool_fn.isdirectory(jetpack_path) then
--     vim.fn.system({
--         "git",
--         "clone",
--         "https://github.com/tani/vim-jetpack.git",
--         jetpack_path,
--     })
-- end

-- vim.cmd([[packadd vim-jetpack]])
vim.cmd([[exec 'source' expand('~/plugin/vim-jetpack/plugin/jetpack.vim')]])

require("jetpack.packer").startup(function(use)
    -- itself
    use({ "tani/vim-jetpack", opt = true })

    -- improved require()
    use("lewis6991/impatient.nvim")

    -- library
    use({
        "nvim-lua/plenary.nvim",
        config = 'require("rc.plugins.config.plenary")',
    })
    use("kyazdani42/nvim-web-devicons")
    use("tami5/sqlite.lua")
    use("uga-rosa/lua-utils.nvim")
    use("Shougo/pum.vim")
    use("vim-denops/denops.vim")
    use("antoinemadec/FixCursorHold.nvim")

    -- colorscheme
    use({
        "bluz71/vim-nightfly-guicolors",
        config = 'require("rc.plugins.config.vim-nightfly-guicolors")',
    })

    -- status line
    use({
        "feline-nvim/feline.nvim",
        event = { "BufRead", "BufNewFile" },
        setup = 'require("rc.plugins.setup.feline")',
        config = 'require("rc.plugins.config.feline")',
    })

    -- snippet engine
    use({
        "L3MON4D3/LuaSnip",
        config = 'require("rc.plugins.config.LuaSnip")',
    })

    -- completion
    use({
        "hrsh7th/nvim-cmp",
        config = 'require("rc.plugins.config.nvim-cmp")',
    })

    -- cmp's sources
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lua")
    use("hrsh7th/cmp-nvim-lsp-signature-help")
    use("hrsh7th/cmp-emoji")
    use("hrsh7th/cmp-cmdline")
    use("saadparwaiz1/cmp_luasnip")
    use("uga-rosa/cmp-latex-symbol")
    use({
        "uga-rosa/cmp-dictionary",
        config = 'require("rc.plugins.config.cmp-dictionary")',
    })
    -- use({
    --     "uga-rosa/cmp-dynamic",
    --     config = 'require("rc.plugins.config.cmp-dynamic")',
    -- })

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
    use("nvim-telescope/telescope-ui-select.nvim")

    -- LSP configuration
    use("neovim/nvim-lspconfig")

    -- easily install and manage LSP servers, DAP servers, linters, and formatters.
    use({
        "williamboman/mason.nvim",
        config = 'require("rc.plugins.config.mason")',
    })
    use({
        "williamboman/mason-lspconfig.nvim",
        config = 'require("rc.plugins.config.mason-lspconfig")',
    })

    -- utilities for nvim-lsp
    use({
        "glepnir/lspsaga.nvim",
        branch = "main",
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
        run = ":TSUpdate",
        config = 'require("rc.plugins.config.nvim-treesitter")',
    })

    use("nvim-treesitter/nvim-treesitter-textobjects")
    use("p00f/nvim-ts-rainbow")
    use({
        "nvim-treesitter/playground",
        after = "nvim-treesitter",
    })

    -- filer
    use({
        "lambdalisue/fern.vim",
        config = 'require("rc.plugins.config.fern")',
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
        setup = 'require("rc.plugins.setup.vim-quickrun")',
    })
    use("lambdalisue/vim-quickrun-neovim-job")

    -- utilities for search
    use({
        "hrsh7th/vim-searchx",
        setup = 'require("rc.plugins.setup.searchx")',
    })

    -- jump to anywhere!
    use({
        "yuki-yano/fuzzy-motion.vim",
        setup = 'vim.keymap.set("n", "ss", "<Cmd>FuzzyMotion<CR>")',
    })

    -- open browser
    use({
        "tyru/open-browser.vim",
        setup = 'require("rc.plugins.setup.open-browser")',
    })

    -- change window
    use("simeji/winresizer")

    -- comment out
    use("tpope/vim-commentary")

    -- translate
    use({
        "uga-rosa/translate.nvim",
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
        "uga-rosa/ccc.nvim",
        config = 'require("rc.plugins.config.ccc")',
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
        "uga-rosa/vim-gindent",
        config = 'require("rc.plugins.config.gindent")',
    })

    -- nim
    use("alaviss/nim.nvim")

    use("uga-rosa/todo.nvim")
    use("uga-rosa/join.nvim")

    use("uga-rosa/nvim-kit")

    use({
        "uga-rosa/linkformat.vim",
        config = 'require("rc.plugins.config.linkformat")',
    })

    use("thinca/vim-partedit")

    -- gitter client
    use("4513ECHO/denops-gitter.vim")
end)
