local null = require("null-ls")
local b = null.builtins
local sources = {
  b.formatting.stylua.with({
    condition = function(utils)
      return utils.root_has_file("stylua.toml")
    end,
  }),
  b.formatting.shfmt.with({
    extra_args = { "-ci", "-s", "-bn", "-i", "2" },
  }),
  b.formatting.fixjson,
  b.formatting.black,
  b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
  b.diagnostics.teal,
}

null.config({ sources = sources })
