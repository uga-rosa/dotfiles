local fn = vim.fn
local path = utils.path

local M = {}

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

M.lua = function()
	local stylua_toml = fn.getcwd() .. "/stylua.toml"
    print(stylua_toml)
	if fn.filereadable(stylua_toml) ~= 0 then
        print(path.readfile(stylua_toml))
		for line in path.lines(stylua_toml) do
			print(line)
		end
	end
end

return M
