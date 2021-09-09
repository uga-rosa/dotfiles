local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

ls.snippets = {
  markdown = {
    s("slide_init", {
      t("% "),
      i(1, "Title"),
      t({ "", "% 中井 剛志", "% " .. os.date("%Y/%m/%d"), "", "" }),
    }),
    s("bracket", {
      c(1, { t([[\left(]]), t([[\left\{]]), t([[\left[]]) }),
      i(0),
    }),
  },
}
