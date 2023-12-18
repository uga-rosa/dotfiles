local helper = require("rc.helper.lsp")
local lspconfig = require("lspconfig")
local root_pattern = lspconfig.util.root_pattern

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
  },
  settings = {
    typescript = {
      inlayHints = helper.typescriptInlayHints,
    },
  },
}
