local helper = require("rc.helper.lsp")

---@type LazySpec
local spec = {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "ddc-source-nvim-lsp",
      {
        "williamboman/mason.nvim",
        config = function()
          require("mason").setup()
        end,
      },
      "williamboman/mason-lspconfig.nvim",
      {
        "j-hui/fidget.nvim",
        tag = "legacy",
        config = function()
          require("fidget").setup()
        end,
      },
      {
        "matsui54/denops-signature_help",
        dependencies = "vim-denops/denops.vim",
        config = function()
          vim.fn["signature_help#enable"]()
        end,
      },
      "b0o/SchemaStore.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")

      require("ddc_nvim_lsp_setup").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "vimls",
          "gopls",
          "pyright",
          "bashls",
          "vtsls",
          "jsonls",
          "yamlls",
        },
      })

      helper.on_attach(nil, function(client, bufnr)
        local buf_map = function(lhs, rhs)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr })
        end

        buf_map("K", vim.lsp.buf.hover)
        buf_map("[d", vim.diagnostic.goto_prev)
        buf_map("]d", vim.diagnostic.goto_next)
        buf_map("<Space>n", vim.lsp.buf.rename)
        buf_map("<Space>F", "<Cmd>Format<CR>")

        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
            vim.lsp.buf.format()
          end, {})
        end

        if client.server_capabilities.inlayHintProvider then
          vim.api.nvim_buf_create_user_command(bufnr, "InlayHintEnable", function()
            vim.lsp.inlay_hint(bufnr, true)
          end, {})
          vim.api.nvim_buf_create_user_command(bufnr, "InlayHintDisable", function()
            vim.lsp.inlay_hint(bufnr, false)
          end, {})
        end
      end)

      local local_server = {
        "denols",
      }
      for _, server_name in ipairs(local_server) do
        lspconfig[server_name].setup(require("rc.plugins.lsp." .. server_name))
      end

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local ok, opt = pcall(require, "rc.plugins.lsp." .. server_name)
          lspconfig[server_name].setup(ok and opt or {})
        end,
      })
    end,
  },
  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("barbecue").setup({
        attach_navic = true,
      })
    end,
  },
  {
    "neoclide/coc.nvim",
    cond = false,
    branch = "release",
  },
  {
    "prabirshrestha/vim-lsp",
    cond = false,
    config = function()
      vim.g.lsp_settings_filetype_typescript = { "deno" }
      vim.fn["lsp#enable"]()
    end,
  },
  {
    "mattn/vim-lsp-settings",
    cond = false,
  },
}

return spec
