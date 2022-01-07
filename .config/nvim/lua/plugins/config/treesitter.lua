local map = vim_api.map
local augroup = vim_api.augroup

require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    highlight = {
        enable = true,
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
        extend_mode = true,
        max_file_lines = nil,
    },
})

map("x", "iu", ':lua require("treesitter-unit").select()<cr>', "noremap")
map("x", "au", ':lua require("treesitter-unit").select(true)<cr>', "noremap")
map("o", "iu", '<cmd>lua require("treesitter-unit").select()<cr>', "noremap")
map("o", "au", '<cmd>lua require("treesitter-unit").select(true)<cr>', "noremap")

local tsunit = require("treesitter-unit")

local operators = { "c", "d", "y", "=", "<", ">" }
for _, o in ipairs(operators) do
    map("n", o, '<cmd>lua require("treesitter-unit").enable_highlighting()<cr>' .. o, "noremap")
end

augroup({ tsunit = { "CursorMoved", "*", tsunit.disable_highlighting } })
