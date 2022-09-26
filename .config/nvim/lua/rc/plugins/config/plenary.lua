vim.api.nvim_create_user_command("Profile", function()
    vim.cmd([[
        profile start ~/profile.txt
        profile func *
    ]])
    local profile = require("plenary.profile")
    profile.start(vim.fn.expand("~/profile.txt"))

    vim.api.nvim_create_autocmd("VimLeave", {
        pattern = "*",
        callback = profile.stop,
    })
end, {})
