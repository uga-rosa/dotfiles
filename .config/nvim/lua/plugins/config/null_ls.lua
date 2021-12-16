local null = require("null-ls")
local b = null.builtins
local h = require("null-ls.helpers")

null.setup({
    sources = {
        h.conditional(function(utils)
            if utils.root_has_file("stylua.toml") then
                return b.formatting.stylua
            elseif utils.root_has_file(".stylua.toml") then
                return b.formatting.stylua.with({
                    extra_args = { "--config-path", "./.stylua.toml" },
                })
            else
                return b.formatting.stylua.with({
                    extra_args = { "--config-path", vim.fn.expand("~/.config/stylua.toml") },
                })
            end
        end),
        b.formatting.shfmt.with({
            extra_args = { "-ci", "-s", "-bn", "-i", "4" },
        }),
        b.formatting.fixjson,
        b.formatting.black,
        b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
        b.diagnostics.teal,
    },
})
