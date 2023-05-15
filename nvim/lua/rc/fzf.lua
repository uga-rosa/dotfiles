local utils = require("fzf-lua.utils")
local path = require("fzf-lua.path")
local root_pattern = require("lspconfig.util").root_pattern

local M = {}

---@see https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/actions.lua
function M.file_tabedit(...)
  local search_root = root_pattern(...)
  return function(selected, opts)
    local is_term = utils.is_term_buffer(0)
    for i = 1, #selected do
      local entry = path.entry_to_file(selected[i], opts, opts.force_uri)
      if entry.path == "<none>" then
        goto continue
      end
      entry.ctag = opts._ctag and path.entry_to_ctag(selected[i])
      local fullpath = entry.path or entry.uri and entry.uri:match("^%a+://(.*)")
      if not path.starts_with_separator(fullpath) then
        fullpath = path.join({ opts.cwd or vim.loop.cwd(), fullpath })
      end
      if not is_term then
        vim.cmd("normal! m`")
      end
      if entry.path then
        local relpath = path.relative(entry.path, vim.loop.cwd())
        entry.path = vim.fn.fnameescape(relpath)
      end
      vim.cmd.tabedit(entry.path)

      -----------------------
      -- Set tab-local cwd --
      -----------------------
      local root = search_root(fullpath)
      if root then
        vim.cmd.tcd(root)
      end

      if entry.uri then
        vim.lsp.util.jump_to_location(entry, "utf-16")
      elseif entry.ctag then
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
        vim.fn.search(entry.ctag, "W")
      elseif entry.line > 1 or entry.col > 1 then
        entry.col = entry.col and entry.col > 0 and entry.col or 1
        vim.api.nvim_win_set_cursor(0, { tonumber(entry.line), tonumber(entry.col) - 1 })
      end
      if not is_term and not opts.no_action_zz then
        vim.cmd("norm! zvzz")
      end
      ::continue::
    end
  end
end

return M
