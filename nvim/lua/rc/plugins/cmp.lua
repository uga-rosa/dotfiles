local kind = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "",
}

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.keycode(key), mode or "", true)
end

local function jump_next(fallback)
  if vim.fn["vsnip#jumpable"](1) == 1 then
    feedkey("<Plug>(vsnip-jump-next)")
  else
    fallback()
  end
end

local function jump_prev(fallback)
  if vim.fn["vsnip#jumpable"](-1) == 1 then
    feedkey("<Plug>(vsnip-jump-prev)")
  else
    fallback()
  end
end

local function get_visible_buffers()
  local bufs = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
    if byte_size < 1024 * 1024 then
      table.insert(bufs, buf)
    end
  end
  return bufs
end

---@type LazySpec
local spec = {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      {
        "hrsh7th/vim-vsnip",
        init = function()
          vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
          vim.g.vsnip_choice_delay = 200
        end,
      },
      {
        "uga-rosa/cmp-skkeleton",
        dependencies = "vim-skk/skkeleton",
      },
      {
        "uga-rosa/cmp-dictionary",
        name = "cmp-dictionary",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
          local dict = require("cmp_dictionary")
          dict.setup({
            exact = 2,
            first_case_insensitive = true,
            document = true,
          })
          dict.switcher({
            filetype = {
              autohotkey = "~/dotfiles/dict/ahk.dict",
            },
            spelllang = {
              en = "~/.dict/en.dict",
            },
          })
        end,
      },
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        enabled = function()
          local disabled = false
          disabled = disabled or vim.fn.empty(vim.g.cmp_disabled) == 0
          disabled = disabled or vim.list_contains({ "ddu-ff-filter" }, vim.bo.filetype)
          disabled = disabled or (vim.api.nvim_buf_get_option(0, "buftype") == "prompt")
          disabled = disabled or (vim.fn.reg_recording() ~= "")
          disabled = disabled or (vim.fn.reg_executing() ~= "")
          return not disabled
        end,
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        preselect = cmp.PreselectMode.None,
        completion = {
          get_trigger_characters = function(trigger_characters)
            return vim.tbl_filter(function(char)
              return char ~= " "
            end, trigger_characters)
          end,
        },
        formatting = {
          format = function(entry, vim_item)
            vim_item.kind = kind[vim_item.kind] .. " " .. vim_item.kind
            vim_item.menu = ({
              buffer = "[Buffer]",
              path = "[Path]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[Lua]",
              vsnip = "[VSnip]",
              dictionary = "[Dict]",
              skkeleton = "[Skk]",
            })[entry.source.name]
            vim_item.dup = ({
              buffer = 0,
              nvim_lua = 0,
              dictionary = 0,
            })[entry.source.name] or 1
            return vim_item
          end,
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find("^_+")
              local _, entry2_under = entry2.completion_item.label:find("^_+")
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under < entry2_under then
                return true
              elseif entry1_under > entry2_under then
                return false
              end
            end,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        mapping = {
          ["<C-space>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.close()
            else
              cmp.complete()
            end
          end, { "i", "c" }),
          ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<Tab>"] = cmp.mapping({
            i = jump_next,
            s = jump_next,
            c = function()
              if cmp.visible() then
                cmp.select_next_item()
              else
                cmp.complete()
              end
            end,
          }),
          ["<S-Tab>"] = cmp.mapping({
            i = jump_prev,
            s = jump_prev,
            c = function()
              if cmp.visible() then
                cmp.select_prev_item()
              else
                cmp.complete()
              end
            end,
          }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = "skkeleton" },
          { name = "vsnip" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "path" },
          {
            name = "buffer",
            option = {
              get_bufnrs = get_visible_buffers,
            },
          },
          {
            name = "dictionary",
            keyword_length = 2,
            priority = 1,
          },
        },
      })

      cmp.setup.cmdline("/", {
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        sources = {
          { name = "cmdline" },
          { name = "path" },
        },
      })

      cmp.setup.cmdline("@", {
        sources = {
          { name = "buffer" },
        },
      })

      cmp.event:on("confirm_done", require("rc.autopairs").on_confirm_done())
    end,
  },
}

return spec
