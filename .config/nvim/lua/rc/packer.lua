local fn = vim.fn

local group_name = "vimrc_packer"
vim.api.nvim_create_augroup(group_name, { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*lua/rc/plugins/list.lua",
    callback = function()
        vim.cmd("luafile %")
        vim.cmd("PackerCompile")
    end,
})

if fn.filereadable(fn.stdpath("config") .. "/lua/rc/packer_compiled.lua") == 1 then
    require("rc.packer_compiled")
end
