local helper = require("rc.helper.lsp")
local lspconfig = require("lspconfig")
local root_pattern = lspconfig.util.root_pattern

return {
  root_dir = function(fname)
    if helper.in_node_repo(fname) then
      return root_pattern(unpack(helper.root_dir.node))(fname)
    end
  end,
  single_file_support = false,
  settings = {
    typescript = {
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = helper.typescriptInlayHints,
    },
  },
}
