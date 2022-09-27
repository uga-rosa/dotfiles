local map = Keymap.set

map("i", "<C-l>", "<Plug>(skkeleton-toggle)")

vim.fn["skkeleton#config"]({
    globalDictionaries = {
        "~/.dict/SKK-JISYO.L",
    },
})
