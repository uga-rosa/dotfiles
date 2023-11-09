local helper = require("rc.helper.lsp")
local lspconfig = require("lspconfig")
local root_pattern = lspconfig.util.root_pattern

helper.on_attach("denols", function(_, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
    vim.lsp.buf.format({
      filter = function(c)
        -- Enable only deno fmt (disable prettier)
        return c.name == "denols"
      end,
    })
  end, {})
end)

return {
  root_dir = function(fname)
    if not helper.in_node_repo(fname) then
      return root_pattern(unpack(helper.root_dir.deno))(fname)
    end
  end,
  init_options = {
    enable = true,
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
    inlayHints = helper.typescriptInlayHints,
  },
}
