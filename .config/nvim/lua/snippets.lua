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
    s("code", {
      t("```"),
      c(
        1,
        { i(1, "rust"), sn(1, { t('{.numberLines caption="'), i(1, "filename"), t('"}') }) }
      ),
      t({ "", "" }),
      i(0),
      t({ "", "```" }),
    }),
    s("bracket", {
      c(1, { t([[\left(]]), t([[\left\{]]), t([[\left[]]) }),
      i(0),
    }),
  },
}
