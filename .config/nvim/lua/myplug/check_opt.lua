local all_options = vim.api.nvim_get_all_options_info()

for i, v in pairs(all_options) do
  if v.was_set and vim.opt[i]:get() == v.default then
    vim.notify(i .. " is same as default value.")
    vim.fn.matchadd("Search", ([[\V%s]]):format(i))
  end
end
