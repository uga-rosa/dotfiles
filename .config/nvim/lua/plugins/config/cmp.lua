local cmp = require("cmp")

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
    snippy = {
      name = "snippy",
      priority = 200,
    },
    vsnip = {
      name = "vsnip",
      priority = 200,
    },
    dictionary = {
      name = "dictionary",
      keyword_length = 2,
      priority = 1,
    },
  }
  local res = {}
  for i = 1, #arr do
    res[i] = config[arr[i]]
  end
  return res
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
      -- vim.fn["vsnip#anonymous"](args.body)
      require("snippy").expand_snippet(args.body)
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
    format = function(entry, vim_item)
      vim_item.kind = lspkind[vim_item.kind] .. " " .. vim_item.kind
      vim_item.menu = ({
        buffer = "[Buffer]",
        path = "[Path]",
        nvim_lsp = "[LSP]",
        -- vsnip = "[Vsnip]",
        snippy = "[Snippy]",
        dictionary = "[Dictionary]",
      })[entry.source.name]
      vim_item.dup = ({
        buffer = 0,
        dictionary = 0,
      })[entry.source.name] or 1
      return vim_item
    end,
  },
  sorting = {
    comparators = {
      cmp.config.compare.offset,
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
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<C-space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  },
  sources = source_list({ "snippy", "lsp", "path", "buffer", "dictionary" }),
})

local map = require("snippy.mapping")
map.setup({
  ["<C-j>"] = {
    func = map.jump_next(),
    mode = { "i", "s" },
  },
  ["<C-k>"] = {
    func = map.jump_prev(),
    mode = { "i", "s" },
  },
})

myutils.map("s", "<C-h>", "x<bs>", "noremap")
