local formatter = require("rc.helper.formatter")

return {
  attach = function(bufnr)
    vim.fn["lspoints#attach"]("denols", {
      cmd = { "deno", "lsp" },
      initializationOptions = {
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
    })

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
      formatter.stdin("deno fmt -")
    end, {})

    vim.api.nvim_buf_create_user_command(bufnr, "DenoCache", function()
      vim.fn["lspoints#request"]("denols", "deno/cache", {
        referrer = {
          uri = vim.uri_from_bufnr(bufnr),
        },
        uris = {},
      })
    end, {})
  end,
}
