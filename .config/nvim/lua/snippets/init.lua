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
      t("\\left"),
      c(1, { t("("), t("\\{"), t("[") }),
      t(" "),
      i(0),
      t(" \\right"),
      f(function(args)
        local open2close = { ["("] = ")", ["\\{"] = "\\}", ["["] = "]" }
        return open2close[args[1][1]]
      end, 1),
    }),
  },
  nim = {
    s("import", {
      t("import "),
      i(1, "module"),
      c(2, { t(""), sn(nil, { t(" except "), i(1, "symbol") }) }),
    }),
    s("from import", {
      t("from "),
      i(1, "module"),
      c(3, { t(""), sn(nil, { t(" as "), i(1, "name") }) }),
      t(" import "),
      i(2, "symbol"),
    }),
  },
}
