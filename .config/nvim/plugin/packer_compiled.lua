-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/uga/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/uga/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/uga/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/uga/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/uga/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    config = { 'require("plugins.luasnip")' },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/LuaSnip"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/cmp-buffer"
  },
  ["cmp-emoji"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/cmp-emoji"
  },
  ["cmp-latex-symbols"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/cmp-latex-symbols"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/cmp_luasnip"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/friendly-snippets"
  },
  fzf = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/fzf.vim"
  },
  ["lexima.vim"] = {
    config = { 'require("plugins.lexima")' },
    loaded = false,
    needs_bufread = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/lexima.vim"
  },
  ["nvim-cmp"] = {
    config = { 'require("plugins.cmp")' },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    config = { 'require("plugins.lsp")' },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-toggleterm.lua"] = {
    config = { 'require("plugins.toggleterm")' },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/nvim-toggleterm.lua"
  },
  ["nvim-treesitter"] = {
    config = { 'require("plugins.treesitter")' },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["open-browser.vim"] = {
    config = { 'require("plugins.other").openbrowser()' },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/open-browser.vim"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["registers.nvim"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/registers.nvim"
  },
  ["rust-tools.nvim"] = {
    config = { 'require("rust-tools").setup({})' },
    loaded = false,
    needs_bufread = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/rust-tools.nvim"
  },
  ["telescope.nvim"] = {
    config = { 'require("plugins.telescope")' },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["treesitter-unit"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/treesitter-unit"
  },
  ["vim-easy-align"] = {
    config = { 'require("plugins.other").easyalign()' },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/vim-easy-align"
  },
  ["vim-nightfly-guicolors"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/vim-nightfly-guicolors"
  },
  ["vim-operator-replace"] = {
    config = { 'require("plugins.other").operator_replace()' },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/vim-operator-replace"
  },
  ["vim-operator-user"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/vim-operator-user"
  },
  ["vim-sandwich"] = {
    config = { 'require("plugins.sandwich")' },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/vim-sandwich"
  },
  ["vimdoc-ja"] = {
    config = { 'vim.o.helplang = "ja,en"' },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/vimdoc-ja"
  },
  ["zoxide.vim"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/zoxide.vim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: vim-operator-replace
time([[Config for vim-operator-replace]], true)
require("plugins.other").operator_replace()
time([[Config for vim-operator-replace]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
require("plugins.treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: vim-sandwich
time([[Config for vim-sandwich]], true)
require("plugins.sandwich")
time([[Config for vim-sandwich]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
require("plugins.cmp")
time([[Config for nvim-cmp]], false)
-- Config for: LuaSnip
time([[Config for LuaSnip]], true)
require("plugins.luasnip")
time([[Config for LuaSnip]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
require("plugins.lsp")
time([[Config for nvim-lspconfig]], false)
-- Config for: vim-easy-align
time([[Config for vim-easy-align]], true)
require("plugins.other").easyalign()
time([[Config for vim-easy-align]], false)
-- Config for: open-browser.vim
time([[Config for open-browser.vim]], true)
require("plugins.other").openbrowser()
time([[Config for open-browser.vim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
require("plugins.telescope")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-toggleterm.lua
time([[Config for nvim-toggleterm.lua]], true)
require("plugins.toggleterm")
time([[Config for nvim-toggleterm.lua]], false)
-- Config for: vimdoc-ja
time([[Config for vimdoc-ja]], true)
vim.o.helplang = "ja,en"
time([[Config for vimdoc-ja]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType rust ++once lua require("packer.load")({'rust-tools.nvim'}, { ft = "rust" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'lexima.vim'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
