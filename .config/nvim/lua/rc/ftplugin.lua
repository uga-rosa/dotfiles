local M = setmetatable({}, {
    __call = function(self, ft)
        self["*"]()
        if self[ft] then
            self[ft]()
        end
    end,
})

local function set_indent(tab_size, is_hard_tab)
    if is_hard_tab then
        vim.bo.expandtab = false
    else
        vim.bo.expandtab = true
    end

    vim.bo.shiftwidth = tab_size
    vim.bo.softtabstop = tab_size
    vim.bo.tabstop = tab_size
end

M["*"] = function()
    vim.opt_local.formatoptions:remove({ "t", "c", "r", "o" })
    vim.opt_local.formatoptions:append("mMBl")
end

M.vim = function()
    set_indent(4, true)
end

M.help = function()
    set_indent(4, true)
end

M.qf = function()
    set_indent(4, true)
end

M.sh = function()
    set_indent(2, false)
end

M.nim = function()
    set_indent(2, false)
end

local group_name = "ftplugin_lua"
vim.api.nvim_create_augroup(group_name, {})
vim.api.nvim_create_autocmd("FileType", {
    group = group_name,
    pattern = "*",
    callback = function(args)
        local ft = args.match
        M(ft)
    end,
})
