local M = {}

M.cache_pending = {}
M.cache_ongoing = 0

function M.cache_file(path)
  if M.cache_ongoing > 5 then
    M.cache_pending[path] = true
    return
  end
  M.cache_ongoing = M.cache_ongoing + 1
  vim.system({ "deno", "cache", path }, {}, function()
    M.cache_pending[path] = nil
    M.cache_ongoing = M.cache_ongoing - 1
    if M.cache_ongoing == 0 and vim.tbl_isempty(M.cache_pending) then
      vim.notify("deno cache done")
      return
    end
    for pending, _ in pairs(M.cache_pending) do
      M.cache_pending[pending] = nil
      M.cache_file(pending)
    end
  end)
end

function M.cache_dir(dir)
  for plugin in vim.fs.dir(dir) do
    vim.system(
      { "fd", ".", "denops", "--type", "f", "-e", "ts" },
      { cwd = vim.fs.joinpath(dir, plugin) },
      function(fd)
        if fd.stdout ~= "" then
          for path in vim.gsplit(fd.stdout, "\n", { trimempty = true }) do
            M.cache_file(vim.fs.joinpath(dir, plugin, path))
          end
        end
      end
    )
  end
end

function M.cache_denops_plugins()
  local root = require("lazy.core.config").options.root
  local dev_root = require("lazy.core.config").options.dev.path
  M.cache_dir(root)
  M.cache_dir(dev_root)
end

return M
