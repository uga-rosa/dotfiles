return {
  attach = function()
    vim.fn["lspoints#attach"]("denols", {
      cmd = { "deno", "lsp" },
      initializationOptions = {
        enable = true,
        lint = true,
        unstable = true,
        suggest = {
          completeFunctionCalls = true,
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
  end,
  mapping = function()
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = true })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = true })
    vim.keymap.set("n", "<Space>F", function()
      vim.fn["denops#request"](
        "lspoints",
        "executeCommand",
        { "format", "execute", vim.fn.bufnr() }
      )
    end)
    vim.keymap.set("n", "K", function()
      vim.fn["denops#request"]("lspoints", "executeCommand", { "hover", "execute", vim.fn.bufnr() })
    end)
  end,
}
