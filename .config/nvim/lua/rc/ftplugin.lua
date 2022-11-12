local M = setmetatable({}, {
    __call = function(self, ft)
        self["*"]()
        if self[ft] then
            self[ft]()
        end
    end,
})

local function set_indent(tab_size, is_hard_tab)
    vim.opt_local.expandtab = not is_hard_tab
    vim.opt_local.tabstop = tab_size
    vim.opt_local.softtabstop = tab_size
    vim.opt_local.shiftwidth = tab_size
end

M["*"] = function()
    vim.opt_local.formatoptions:remove({ "t", "c", "r", "o" })
    vim.opt_local.formatoptions:append("mMBl")
end

M.typescript = function()
    set_indent(2)
end

M.toml = function()
    set_indent(4)
end

M.vim = function()
    set_indent(2)
end

M.help = function()
    set_indent(8, true)
end

M.qf = function()
    set_indent(4, true)
end

M.sh = function()
    set_indent(2)
end

M.nim = function()
    set_indent(2)
end

M.python = function()
    set_indent(4)
end

M.html = function()
    set_indent(2)
end

M.xhtml = function()
    set_indent(2)
end

M.lua = function()
    local ok, Path = pcall(require, "plenary.path")
    if not ok then
        return
    end

    local tab_size, is_hard_tab

    local stylua = Path:new("stylua.toml")
    if stylua:exists() then
        for line in stylua:iter() do
            if line:find("indent_type") then
                is_hard_tab = line:find("Tabs") ~= nil
            elseif line:find("indent_width") then
                tab_size = tonumber(line:match("%d+"))
            end
        end
        set_indent(tab_size, is_hard_tab)
    end
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
