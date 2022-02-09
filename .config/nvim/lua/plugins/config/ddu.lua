vim.fn["ddu#custom#patch_global"]({
    ui = "std",
    sourceOptions = {
        _ = {
            matchers = { "matcher_substring" },
        },
    },
})

vim.fn["ddu#custom#patch_global"]("sourceParams", {
    file = { path = vim.fn.expand("~") },
})
