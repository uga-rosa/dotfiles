_G.pasteimage = function()
  local time = vim.fn.strftime("%Y-%m-%d-%H-%M-%S")
  local filepath = vim.fn.expand("%:p:h")
  vim.fn.mkdir(filepath .. "/png", "p")
  local handle = io.popen("wslpath -w " .. filepath)
  local result = handle:read("*l")
  handle:close()
  local savepath = result .. "\\png\\" .. time .. ".png"
  vim.cmd(
    [[!powershell.exe -c '(Get-Clipboard -Format Image).Save("]] .. savepath .. [[")']]
  )
  vim.api.nvim_set_current_line("![](png/" .. time .. ".png)")
end

vim.cmd([[command! PasteImage lua _G.pasteimage()]])
