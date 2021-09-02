local res, gitsigns = pcall(require, "gitsigns")
if not res then
  return
end

gitsigns.setup({})
