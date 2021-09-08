local res, cmp = pcall(require, "cmp")
if not res then
  return
end

local augroup = utils.augroup

_G.source_list = function(arr)
  local config = {
    buffer = {
      name = "buffer",
      opts = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
    path = { name = "path" },
    emoji = { name = "emoji" },
    lsp = { name = "nvim_lsp" },
    luasnip = { name = "luasnip" },
    nvim_lua = { name = "nvim_lua" },
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
  formatting = {
    deprecated = false,
    format = function(entry, vim_item)
      vim_item.kind = lspkind[vim_item.kind] .. " " .. vim_item.kind
      vim_item.menu = ({
        buffer = "[Buffer]",
        path = "[Path]",
        emoji = "[emoji]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
      })[entry.source.name]
      vim_item.dup = ({
        nvim_lua = 0,
        buffer = 0,
      })[entry.source.name] or 1
      return vim_item
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  },
  sources = source_list({ "luasnip", "lsp", "buffer", "path", "emoji" }),
  event = {
    on_confirm_done = function(entry)
      local Method = cmp.lsp.CompletionItemKind.Method
      local Function = cmp.lsp.CompletionItemKind.Function
      local item = entry:get_completion_item()
      if vim.tbl_contains({ Method, Function }, item.kind) then
        if
          (
            item.textEdit
            and item.textEdit.newText
            and item.textEdit.newText:match("[%(%[]")
          ) or (item.insertText and item.insertText:match("[%(%[]"))
        then
          return
        end
        vim.api.nvim_feedkeys("(", "", true)
      end
    end,
  },
})

augroup({
  MyCmp = {
    {
      "FileType",
      "lua",
      function()
        require("cmp").setup.buffer({
          sources = source_list({ "luasnip", "lsp", "nvim_lua", "buffer", "path" }),
        })
      end,
    },
  },
})
