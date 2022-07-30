local ftplugin = require("rc.ftplugin")

vim.api.nvim_create_augroup("vimrc_filetype", {})
vim.api.nvim_create_autocmd("FileType", {
	group = "vimrc_filetype",
	pattern = "*",
	callback = function(args)
		-- Global setting
		ftplugin["*"]()
		-- Settings for each filetype
		local setting = ftplugin[args.match]
		if setting then
			setting()
		end
	end,
})
