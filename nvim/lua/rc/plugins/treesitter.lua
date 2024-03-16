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

      vim.treesitter.start = (function(wrapped)
        return function(bufnr, lang)
          lang = lang or vim.api.nvim_get_option_value("filetype", { buf = bufnr })
          if lang == "help" or lang == "vimdoc" then
            return
          end
          pcall(wrapped, bufnr, lang)
        end
      end)(vim.treesitter.start)
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
