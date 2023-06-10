---Register callback function on LspAttach
---@param callback fun(client, bufnr)
local function on_attach(callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      callback(client, bufnr)
    end,
  })
end

---@type LazySpec
local spec = {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      {
        "williamboman/mason.nvim",
        config = function()
          require("mason").setup()
        end,
      },
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      {
        "j-hui/fidget.nvim",
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
      local rc = require("rc.utils")

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

      ---@return boolean
      local function is_active(client_name)
        for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
          if client.name == client_name then
            return true
          end
        end
        return false
      end

      on_attach(function(client, bufnr)
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
      end)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local opts = setmetatable({}, {
        __index = function(self, _)
          return self["*"]
        end,
        __newindex = function(self, key, value)
          value.capabilities = capabilities
          rawset(self, key, value)
        end,
      })

      opts["*"] = {}

      ---@param plugins string[]
      ---@return string[]
      local function get_plugin_path(plugins)
        local paths = {}
        local lazyroot = require("lazy.core.config").options.root
        for _, plugin in ipairs(plugins) do
          local path = vim.fs.joinpath(lazyroot, plugin)
          if vim.fs.isdir(path .. "/lua") then
            table.insert(paths, path)
          else
            vim.notify("Invalid plugin name: " .. plugin)
          end
        end
        return paths
      end

      ---@param rocks string[]
      ---@return string[]
      local function get_rock_path(rocks)
        local root = "/usr/local/share/lua/5.1/"
        local paths = {}
        for _, rock in ipairs(rocks) do
          local path = root .. rock
          if vim.bool_fn.isdirectory(path) then
            table.insert(paths, path)
          else
            vim.notify("Invalid rock name: " .. rock)
          end
        end
        return paths
      end

      ---@param plugins string[]
      ---@param rocks string[]
      ---@return string[]
      local function library(plugins, rocks)
        return vim.list_extend(get_plugin_path(plugins), get_rock_path(rocks))
      end

      opts.lua_ls = {
        settings = {
          Lua = {
            format = {
              -- Use stylua
              enable = false,
            },
            diagnostics = {
              globals = {
                "vim",
                "describe",
                "it",
                "before_each",
                "after_each",
                "setup",
                "teardown",
              },
            },
            semantic = {
              enable = false,
            },
            runtime = {
              version = "LuaJIT",
              path = { "?.lua", "?/init.lua" },
            },
            workspace = {
              library = library({ "lazy.nvim" }, { "vusted" }),
              checkThirdParty = false,
            },
          },
        },
      }

      on_attach(function(client, bufnr)
        if client.name ~= "lua_ls" then
          return
        end
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
          if not is_active("null-ls") then
            rc.keep_cursor("%!stylua -f ~/.config/stylua.toml -")
          else
            vim.lsp.buf.format()
          end
        end, {})
      end)

      opts.bashls = {
        filetypes = { "sh", "bash", "zsh" },
      }

      local root_pattern = lspconfig.util.root_pattern

      -- Don't use mason to install (use local deno runtime).
      opts.denols = {
        root_dir = function(fname)
          return root_pattern("deno.json", "deno.jsonc", ".")(fname)
        end,
        init_options = {
          lint = true,
          unstable = true,
          suggest = {
            imports = {
              hosts = {
                ["https://deno.land"] = true,
                ["https://cdn.nest.land"] = true,
                ["https://crux.land"] = true,
              },
            },
          },
        },
      }
      lspconfig.denols.setup(opts.denols)

      opts.vtsls = {
        root_dir = function(fname)
          if not root_pattern("deno.json", "deno.jsonc", ".")(fname) then
            return root_pattern("tsconfig.json")(fname)
              or root_pattern("package.json", "jsconfig.json", ".git")(fname)
          end
        end,
        single_file_support = false,
        settings = {
          typescript = {
            suggest = {
              completionFunctionCalls = true,
            },
          },
        },
      }

      on_attach(function(client, bufnr)
        if client.name ~= "denols" then
          return
        end
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
          vim.lsp.buf.format({
            filter = function(c)
              -- Enable only deno fmt (disable prettier)
              return c.name == "denols"
            end,
          })
        end, {})
      end)

      opts.jsonls = {
        filetypes = { "json", "jsonc" },
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      }

      opts.yamlls = {
        settings = {
          yaml = {
            schemaStore = {
              enable = true,
            },
          },
        },
      }

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          lspconfig[server_name].setup(opts[server_name])
        end,
      })
    end,
  },
  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    dependencies = { "SmiteshP/nvim-navic" },
    config = function()
      require("barbecue").setup()
      on_attach(function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, bufnr)
        end
      end)
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local null = require("null-ls")
      local builtin = null.builtins

      null.setup({
        diagnostics_format = "#{m} (#{s}: #{c})",
        sources = {
          -- stylua (lua; formatter)
          function()
            local utils = require("null-ls.utils").make_conditional_utils()
            if utils.root_has_file("stylua.toml") or utils.root_has_file(".stylua.toml") then
              return builtin.formatting.stylua
            else
              return builtin.formatting.stylua.with({
                extra_args = { "--config-path", vim.fn.expand("~/.config/stylua.toml") },
              })
            end
          end,
          -- prettier
          null.builtins.formatting.prettier,
          -- fixjson (json; formatter)
          builtin.formatting.fixjson,
          -- black (python; formatter)
          builtin.formatting.black,
        },
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
