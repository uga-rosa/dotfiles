require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "toml", "python", "go", "vim" },
    highlight = {
        enable = true,
        disable = { "help" },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["ib"] = "@block.inner",
                ["ab"] = "@block.outer",
                ["c"] = "@comment.outer",
                ["if"] = "@function.inner",
                ["af"] = "@function.outer",
                ["il"] = "@loop.inner",
                ["al"] = "@loop.outer",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<M-s>"] = "@parameter.inner",
            },
            swap_previous = {
                ["<M-S-s>"] = "@parameter.inner",
            },
        },
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
    },
})
