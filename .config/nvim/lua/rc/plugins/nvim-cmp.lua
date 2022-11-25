local api = vim.api
local t = api.nvim_replace_termcodes

local feedkey = function(key, mode)
  api.nvim_feedkeys(t(key, true, true, true), mode or "", true)
end

local cmp = require("cmp")

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

local function is_falsy(v)
  return v == nil or v == false or v == 0
end

cmp.setup({
  enabled = function()
    if not is_falsy(vim.g.cmp_disabled) then
      return false
    end
    local disabled = false
    disabled = disabled or (api.nvim_buf_get_option(0, "buftype") == "prompt")
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
      vim_item.kind = lspkind[vim_item.kind] .. " " .. vim_item.kind
      vim_item.menu = ({
        buffer = "[Buffer]",
        path = "[Path]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[NvimLua]",
        vsnip = "[Vsnip]",
        dictionary = "[Dict]",
        skkeleton = "[Skkeleton]",
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
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
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
    end, {
      "i",
      "c",
    }),
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
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
})

local function get_visible_buffers()
  local bufs = {}
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    local byte_size = api.nvim_buf_get_offset(buf, api.nvim_buf_line_count(buf))
    if byte_size < 1024 * 1024 then
      table.insert(bufs, buf)
    end
  end
  return bufs
end

local function get_sources(name)
  if name == "skkeleton" then
    return {
      { name = "skkeleton" },
    }
  elseif name == "default" then
    return {
      { name = "vsnip" },
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "nvim_lsp_signature_help" },
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
    }
  end
end

CmpSourceSelect = function(name)
  local sources = get_sources(name)
  if sources then
    cmp.setup({
      sources = sources,
    })
  end
end

CmpSourceSelect("default")

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

cmp.event:on("confirm_done", require("autopairs.cmp").on_confirm_done())
