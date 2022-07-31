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
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
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
    after = { "nvim-cmp" },
    config = { 'require("rc.plugins.config.LuaSnip")' },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["cmp-buffer"] = {
    after_files = { "/home/uga/.local/share/nvim/site/pack/packer/opt/cmp-buffer/after/plugin/cmp_buffer.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    after_files = { "/home/uga/.local/share/nvim/site/pack/packer/opt/cmp-cmdline/after/plugin/cmp_cmdline.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-dictionary"] = {
    after_files = { "/home/uga/.local/share/nvim/site/pack/packer/opt/cmp-dictionary/after/plugin/cmp_dictionary.vim" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/cmp-dictionary",
    url = "/home/uga/plugin/cmp-dictionary"
  },
  ["cmp-nvim-lsp"] = {
    after = { "mason-lspconfig.nvim" },
    after_files = { "/home/uga/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp/after/plugin/cmp_nvim_lsp.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-path"] = {
    after_files = { "/home/uga/.local/share/nvim/site/pack/packer/opt/cmp-path/after/plugin/cmp_path.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    after_files = { "/home/uga/.local/share/nvim/site/pack/packer/opt/cmp_luasnip/after/plugin/cmp_luasnip.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["denops.vim"] = {
    config = { 'require("rc.plugins.config.denops-vim")' },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/denops.vim",
    url = "https://github.com/vim-denops/denops.vim"
  },
  ["feline.nvim"] = {
    config = { 'require("rc.plugins.config.feline")' },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/feline.nvim",
    url = "https://github.com/feline-nvim/feline.nvim"
  },
  ["fidget.nvim"] = {
    config = { 'require("fidget").setup({})' },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/fidget.nvim",
    url = "https://github.com/j-hui/fidget.nvim"
  },
  ["fuzzy-motion.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/fuzzy-motion.vim",
    url = "https://github.com/yuki-yano/fuzzy-motion.vim"
  },
  ["gina.vim"] = {
    config = { 'require("rc.plugins.config.gina")' },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/gina.vim",
    url = "https://github.com/lambdalisue/gina.vim"
  },
  ["glance-vim"] = {
    config = { 'require("rc.plugins.config.glance-vim")' },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/glance-vim",
    url = "https://github.com/tani/glance-vim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["lspsaga.nvim"] = {
    after = { "mason-lspconfig.nvim" },
    config = { 'require("rc.plugins.config.lspsaga")' },
    loaded = true,
    only_config = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/lspsaga.nvim",
    url = "https://github.com/glepnir/lspsaga.nvim"
  },
  ["lua-dev.nvim"] = {
    config = { 'require("rc.plugins.config.lua-dev")' },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/lua-dev.nvim",
    url = "https://github.com/uga-rosa/lua-dev.nvim"
  },
  ["luv-vimdocs"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/luv-vimdocs",
    url = "https://github.com/nanotee/luv-vimdocs"
  },
  ["mason-lspconfig.nvim"] = {
    config = { 'require("rc.plugins.config.mason-lspconfig")' },
    load_after = {
      ["cmp-nvim-lsp"] = true,
      ["mason.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    after = { "mason-lspconfig.nvim" },
    config = { 'require("rc.plugins.config.mason")' },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["null-ls.nvim"] = {
    config = { 'require("rc.plugins.config.null-ls")' },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-autopairs"] = {
    config = { 'require("rc.plugins.config.nvim-autopairs")' },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-cmp"] = {
    after = { "cmp-cmdline", "cmp-dictionary", "cmp_luasnip", "cmp-nvim-lsp", "cmp-path", "cmp-buffer" },
    config = { 'require("rc.plugins.config.nvim-cmp")' },
    load_after = {
      LuaSnip = true
    },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-luaref"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/nvim-luaref",
    url = "https://github.com/milisims/nvim-luaref"
  },
  ["nvim-tree.lua"] = {
    config = { 'require("rc.plugins.config.nvim-tree")' },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    after = { "playground" },
    config = { 'require("rc.plugins.config.nvim-treesitter")' },
    loaded = true,
    only_config = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow",
    url = "https://github.com/p00f/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["open-browser.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/open-browser.vim",
    url = "https://github.com/tyru/open-browser.vim"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    load_after = {},
    loaded = true,
    needs_bufread = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { 'require("rc.plugins.config.telescope")' },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["translate.nvim"] = {
    config = { 'require("rc.plugins.config.translate")' },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/translate.nvim",
    url = "/home/uga/plugin/translate.nvim"
  },
  ["treesitter-unit"] = {
    config = { 'require("rc.plugins.config.treesitter-unit")' },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/treesitter-unit",
    url = "https://github.com/David-Kunz/treesitter-unit"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-maketable"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/vim-maketable",
    url = "https://github.com/mattn/vim-maketable"
  },
  ["vim-nightfly-guicolors"] = {
    config = { 'require("rc.plugins.config.vim-nightfly-guicolors")' },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/vim-nightfly-guicolors",
    url = "https://github.com/bluz71/vim-nightfly-guicolors"
  },
  ["vim-operator-replace"] = {
    keys = { { "", "<Plug>(operator-replace)" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/vim-operator-replace",
    url = "https://github.com/kana/vim-operator-replace"
  },
  ["vim-operator-user"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/vim-operator-user",
    url = "https://github.com/kana/vim-operator-user"
  },
  ["vim-quickrun"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/vim-quickrun",
    url = "https://github.com/thinca/vim-quickrun"
  },
  ["vim-quickrun-neovim-job"] = {
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/vim-quickrun-neovim-job",
    url = "https://github.com/lambdalisue/vim-quickrun-neovim-job"
  },
  ["vim-sandwich"] = {
    config = { 'require("rc.plugins.config.vim-sandwich")' },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/vim-sandwich",
    url = "https://github.com/machakann/vim-sandwich"
  },
  ["vim-searchx"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/vim-searchx",
    url = "https://github.com/hrsh7th/vim-searchx"
  },
  ["vimdoc-ja"] = {
    config = { "\27LJ\2\n2\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\nja,en\rhelplang\bopt\bvim\0" },
    loaded = true,
    path = "/home/uga/.local/share/nvim/site/pack/packer/start/vimdoc-ja",
    url = "https://github.com/vim-jp/vimdoc-ja"
  },
  winresizer = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/uga/.local/share/nvim/site/pack/packer/opt/winresizer",
    url = "https://github.com/simeji/winresizer"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: vim-operator-replace
time([[Setup for vim-operator-replace]], true)
vim.cmd("nmap r <Plug>(operator-replace)")
time([[Setup for vim-operator-replace]], false)
-- Setup for: vim-sandwich
time([[Setup for vim-sandwich]], true)
require("rc.plugins.setup.vim-sandwich")
time([[Setup for vim-sandwich]], false)
-- Setup for: gina.vim
time([[Setup for gina.vim]], true)
require("rc.plugins.setup.gina")
time([[Setup for gina.vim]], false)
-- Setup for: vim-searchx
time([[Setup for vim-searchx]], true)
require("rc.plugins.setup.searchx")
time([[Setup for vim-searchx]], false)
-- Setup for: feline.nvim
time([[Setup for feline.nvim]], true)
require("rc.plugins.setup.feline")
time([[Setup for feline.nvim]], false)
-- Setup for: open-browser.vim
time([[Setup for open-browser.vim]], true)
require("rc.plugins.setup.open-browser")
time([[Setup for open-browser.vim]], false)
-- Setup for: vim-quickrun
time([[Setup for vim-quickrun]], true)
require("rc.plugins.setup.vim-quickrun")
time([[Setup for vim-quickrun]], false)
-- Setup for: fuzzy-motion.vim
time([[Setup for fuzzy-motion.vim]], true)
require("rc.plugins.setup.fuzzy-motion")
time([[Setup for fuzzy-motion.vim]], false)
-- Setup for: telescope.nvim
time([[Setup for telescope.nvim]], true)
require("rc.plugins.setup.telescope")
time([[Setup for telescope.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
require("rc.plugins.config.nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: vimdoc-ja
time([[Config for vimdoc-ja]], true)
try_loadstring("\27LJ\2\n2\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\nja,en\rhelplang\bopt\bvim\0", "config", "vimdoc-ja")
time([[Config for vimdoc-ja]], false)
-- Config for: lspsaga.nvim
time([[Config for lspsaga.nvim]], true)
require("rc.plugins.config.lspsaga")
time([[Config for lspsaga.nvim]], false)
-- Config for: lua-dev.nvim
time([[Config for lua-dev.nvim]], true)
require("rc.plugins.config.lua-dev")
time([[Config for lua-dev.nvim]], false)
-- Config for: fidget.nvim
time([[Config for fidget.nvim]], true)
require("fidget").setup({})
time([[Config for fidget.nvim]], false)
-- Config for: null-ls.nvim
time([[Config for null-ls.nvim]], true)
require("rc.plugins.config.null-ls")
time([[Config for null-ls.nvim]], false)
-- Config for: treesitter-unit
time([[Config for treesitter-unit]], true)
require("rc.plugins.config.treesitter-unit")
time([[Config for treesitter-unit]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd playground ]]
vim.cmd [[ packadd nvim-lspconfig ]]
time([[Sequenced loading]], false)
-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.api.nvim_set_keymap("", "<Plug>(operator-replace)", "<cmd>lua require('packer.load')({'vim-operator-replace'}, { keys = '<lt>Plug>(operator-replace)', prefix = '' }, _G.packer_plugins)<cr>", { noremap = true, silent = true })
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType python ++once lua require("packer.load")({'mason-lspconfig.nvim'}, { ft = "python" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'mason-lspconfig.nvim'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType vim ++once lua require("packer.load")({'mason-lspconfig.nvim'}, { ft = "vim" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'glance-vim', 'vim-maketable'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType go ++once lua require("packer.load")({'mason-lspconfig.nvim'}, { ft = "go" }, _G.packer_plugins)]]
vim.cmd [[au FileType sh ++once lua require("packer.load")({'mason-lspconfig.nvim'}, { ft = "sh" }, _G.packer_plugins)]]
vim.cmd [[au FileType nim ++once lua require("packer.load")({'mason-lspconfig.nvim'}, { ft = "nim" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au CursorHold * ++once lua require("packer.load")({'denops.vim'}, { event = "CursorHold *" }, _G.packer_plugins)]]
vim.cmd [[au BufNewFile * ++once lua require("packer.load")({'feline.nvim'}, { event = "BufNewFile *" }, _G.packer_plugins)]]
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-autopairs', 'nvim-cmp', 'LuaSnip'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufEnter * ++once lua require("packer.load")({'vim-quickrun', 'nvim-tree.lua', 'vim-sandwich', 'winresizer', 'gina.vim'}, { event = "BufEnter *" }, _G.packer_plugins)]]
vim.cmd [[au CmdlineEnter * ++once lua require("packer.load")({'nvim-cmp'}, { event = "CmdlineEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufRead * ++once lua require("packer.load")({'vim-searchx', 'feline.nvim', 'fuzzy-motion.vim', 'translate.nvim', 'open-browser.vim'}, { event = "BufRead *" }, _G.packer_plugins)]]
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'telescope.nvim', 'mason.nvim', 'vim-nightfly-guicolors'}, { event = "VimEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
