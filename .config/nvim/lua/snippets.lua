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
    s("pandoc_init", {
      t({ "---", "title: " }),
      i(1),
      t({
        "",
        "author: 分子集積化学研究室 計算グループ B4 中井 剛志",
        "date: " .. os.date("%Y/%m/%d"),
        "",
        "---",
        "",
        "",
      }),
    }),
    s("bracket", {
      c(1, { t([[\left(]]), t([[\left\{]]), t([[\left[]]) }),
      i(0),
    }),
  },
}
