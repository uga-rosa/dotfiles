local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta
local ai = require("luasnip.nodes.absolute_indexer")

ls.snippets = {
    lua = {
        s(
            "class",
            fmta(
                [[
	---@class <>
	local <> = {<>}

	<>
]],
                {
                    rep(1), -- parent-relative indexing still works.
                    i(1, "MyClass"),
                    i(2),
                    c(3, {
                        fmta(
                            [[
			<>function <>:new(o)
				o = o or {}
				setmetatable(o, self)
				self.__index = self
				return o
			end
		]],
                            {
                                i(1),
                                rep(ai[1]), -- refers to first `insertNode` relative to surrounding snippet.
                            }
                        ),
                        t(""),
                    }),
                }
            )
        ),
    },
}
