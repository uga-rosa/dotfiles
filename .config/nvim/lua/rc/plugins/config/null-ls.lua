local null = require("null-ls")
local b = null.builtins

null.setup({
    sources = {
        function()
            local utils = require("null-ls.utils").make_conditional_utils()
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
        end,
        b.formatting.shfmt.with({
            extra_args = { "-ci", "-s", "-bn", "-i", "4" },
        }),
        b.formatting.fixjson,
        b.formatting.black,
        b.diagnostics.teal,
    },
})
