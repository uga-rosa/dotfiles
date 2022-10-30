vim.g.openbrowser_browser_commands = {
    {
        name = "vivaldi.exe",
        args = { "{browser}", "{uri}" },
    },
}
vim.g.openbrowser_search_engines = {
    google = "https://google.com/search?q={query}",
    nim = "https://www.google.com/search?q={query}+site%3Anim-lang.org",
}

vim.keymap.set({ "n", "x" }, "<M-o>", function()
    local engines = vim.g.openbrowser_search_engines
    local engine = vim.bo.filetype
    if not engines[engine] then
        engine = "google"
    end
    vim.g.openbrowser_default_search = engine
    return "<Plug>(openbrowser-smart-search)"
end, { expr = true })
