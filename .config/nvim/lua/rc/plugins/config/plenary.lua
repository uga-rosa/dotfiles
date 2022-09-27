vim.api.nvim_create_user_command("Profile", function()
    vim.cmd([[
        profile start ~/profile.txt
        profile func *
    ]])

    local ok, profile = pcall(require, "plenary.profile")
    if ok then
        profile.start(vim.fn.expand("~/profile.txt"))
        vim.api.nvim_create_autocmd("VimLeave", {
            pattern = "*",
            callback = profile.stop,
        })
    end
end, {})
