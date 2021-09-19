local cmp = require("cmp")
local luasnip = require("luasnip")

_G.source_list = function(arr)
  local config = {
    buffer = {
      name = "buffer",
      opts = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
    path = { name = "path" },
    lsp = { name = "nvim_lsp" },
    luasnip = { name = "luasnip" },
  }
  return vim.tbl_map(function(name)
    return config[name]
  end, arr)
end

local lspkind = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "ﰠ",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "塞",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "פּ",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  completion = {
    get_trigger_characters = function(trigger_characters)
      return vim.tbl_filter(function(char)
        return char ~= " "
      end, trigger_characters)
    end,
  },
  formatting = {
    deprecated = false,
    format = function(entry, vim_item)
      vim_item.kind = lspkind[vim_item.kind] .. " " .. vim_item.kind
      vim_item.menu = ({
        buffer = "[Buffer]",
        path = "[Path]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
      })[entry.source.name]
      vim_item.dup = ({
        buffer = 0,
      })[entry.source.name] or 1
      return vim_item
    end,
  },
  mapping = {
    ["<C-n>"] = cmp.mapping(function()
      if luasnip.choice_active() then
        luasnip.change_choice(1)
      else
        cmp.select_next_item()
      end
    end, {
      "i",
      "s",
    }),
    ["<C-p>"] = cmp.mapping(function()
      if luasnip.choice_active() then
        luasnip.change_choice(-1)
      else
        cmp.select_prev_item()
      end
    end, {
      "i",
      "s",
    }),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  },
  sources = source_list({ "luasnip", "lsp", "buffer", "path" }),
})
