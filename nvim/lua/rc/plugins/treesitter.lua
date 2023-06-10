---@type LazySpec
local spec = {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "p00f/nvim-ts-rainbow",
    },
    event = "VeryLazy",
    build = ":TSUpdate",
    config = function()
      local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter"
      vim.opt.runtimepath:append(parser_install_dir)

      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          disable = { "vimdoc" },
        },
        -- lua, vim. help (vimdoc) parser is in neovim core.
        ensure_installed = {
          "toml",
          "query",
          "markdown",
          "python",
          "go",
          "javascript",
          "typescript",
        },
        parser_install_dir = parser_install_dir,
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["ib"] = "@block.inner",
              ["ab"] = "@block.outer",
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
    end,
  },
}

return spec
