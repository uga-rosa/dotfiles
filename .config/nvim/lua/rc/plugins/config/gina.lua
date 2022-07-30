vim.fn["gina#custom#mapping#nmap"](
    "status",
    "<Space>",
    "<Plug>(gina-index-toggle)",
    {
        buffer = true,
        nowait = true,
        silent = true,
    }
)
vim.fn["gina#custom#mapping#nmap"](
    "status",
    "cc",
    "<Cmd>Gina commit<CR>",
    {
        noremap = true,
        buffer = true,
        nowait = true,
        silent = true,
    }
)
vim.fn["gina#custom#mapping#nmap"](
    "status",
    "q",
    "<Cmd>bd<CR>",
    {
        noremap = true,
        buffer = true,
        nowait = true,
        silent = true,
    }
)
