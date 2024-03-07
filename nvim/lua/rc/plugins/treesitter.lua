---@type PluginSpec
local spec = {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufRead", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter"
      vim.opt.runtimepath:prepend(parser_install_dir)

      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
        },
        -- lua, vim. help (vimdoc) parser is in neovim core.
        ensure_installed = {
          "bash",
          "toml",
          "query",
          "markdown",
          "python",
          "go",
          "javascript",
          "typescript",
        },
        parser_install_dir = parser_install_dir,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
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
      })
    end,
  },
}

return spec
