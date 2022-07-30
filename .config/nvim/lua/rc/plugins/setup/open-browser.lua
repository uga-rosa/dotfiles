vim.g.openbrowser_browser_commands = {
    {
        name = "vivaldi.exe",
        args = { "{browser}", "{uri}" },
    },
}

local map = utils.keymap.set
map("nx", "<M-o>", "<Plug>(openbrowser-smart-search)")
