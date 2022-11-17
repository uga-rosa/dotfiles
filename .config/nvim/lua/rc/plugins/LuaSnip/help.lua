---@diagnostic disable
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
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local extras = require("luasnip.extras")
local m = extras.m
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix
---@diagnostic enable

local WIDTH = 78

---@param include_exe? boolean
---@return string
local function filename(include_exe)
    local expr = "%:t:r"
    if include_exe == true then
        expr = "%:t"
    end
    ---@diagnostic disable-next-line
    return vim.fn.expand(expr)
end

---@param str string
---@return string
local function str2tag(str)
    return ("*%s-%s*"):format(filename(), str)
end

---@param title string
---@param include_title boolean
---@return string
local function section(title, include_title)
    local tag = str2tag(title:lower())
    local width_spaces = WIDTH - #title - (#tag - 2)
    local result = ""
    if include_title then
        result = title
    end
    result = result .. string.rep(" ", width_spaces) .. tag
    return result
end

local function right_padding()
    local tag = vim.trim(vim.api.nvim_get_current_line())
    local width_spaces = WIDTH - (#tag - 2)
    return string.rep(" ", width_spaces)
end

---@return string
local function separator()
    return string.rep("=", WIDTH)
end

ls.add_snippets("help", {
    s("vim_help_init", {
        f(function()
            return ("*%s*"):format(filename(true))
        end),
        t({ "", "", "" }),
        f(separator),
        t({ "", "" }),
        f(function()
            return section("CONTENTS", true)
        end),
        t({ "", "", "", "", "vim:tw=78:ts=8:noet:ft=help:norl:" }),
    }),
    s("new_section", {
        f(separator),
        t({ "", "" }),
        i(1),
        f(function(args)
            return section(args[1][1], false)
        end, { 1 }),
        t({ "", "", "" }),
        i(0),
    }),
    s("tag", {
        f(right_padding, { 1 }),
        t("*"),
        f(filename),
        t("-"),
        i(1),
        t("*"),
    }),
    s("tag_simple", {
        f(right_padding, { 1 }),
        t("*"),
        i(1),
        t("*"),
    }),
})
