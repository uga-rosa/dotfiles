local M = {}

local fn = vim.fn
local api = vim.api

local map = myutils.map
local command = myutils.command
local augroup = myutils.augroup

local sep = "|"

M.make = function(...)
    local args = { ... }

    local line, col = (function()
        if #args == 2 then
            return tonumber(args[1]), tonumber(args[2])
        elseif #args == 0 then
            local input = fn.input("Input table size (line, column): ")
            input = vim.split(input, "[ ,]")
            if #input == 2 then
                return tonumber(input[1]), tonumber(input[2])
            end
        end
        error("Only two arguments.")
    end)()

    assert(line >= 2, "line too small")
    assert(col >= 1, "col too small")

    local thd = sep .. string.rep("     ", col, sep) .. sep
    local boundary = sep .. string.rep(" --- ", col, sep) .. sep

    local tables = { thd, boundary }
    for i = 1, line - 1 do
        tables[i + 2] = thd
    end

    local currentline = fn.line(".")
    api.nvim_buf_set_lines(0, currentline, currentline, true, tables)
end

---Jump between cells.
---dir == 1 mean normal direction, dir == -1 mean opposite direction.
---@param dir integer
M.jump = function(dir)
    local line = fn.getline(".")
    local col = fn.col(".")

    if dir == 1 then
        local search_target = line:sub(col)
        if search_target:match(("%s.+%s"):format(sep, sep)) then
            vim.cmd("normal! f" .. sep .. "2l")
        else
            vim.cmd("normal! j02l")
        end
    elseif dir == -1 then
        local search_target = line:sub(1, col)
        if search_target:match(("%s.+%s"):format(sep, sep)) then
            vim.cmd("normal! 2F" .. sep .. "2l")
        else
            vim.cmd("normal! k$F" .. sep .. "2l")
        end
    end
end

local function trim(str)
    return str:match("^%s*(.-)%s*$")
end

local function transpose(t)
    local res = {}
    for i = 1, #t do
        for j = 1, #t[i] do
            res[j] = res[j] or {}
            res[j][i] = t[i][j]
        end
    end
    return res
end

local function _max_width(t)
    local res = fn.strwidth(t[1])
    for i = 2, #t do
        local width = fn.strwidth(t[i])
        if res < width then
            res = width
        end
    end
    return res
end

local function max_col_width(arr)
    local res = {}
    local t = transpose(arr)
    for i = 1, #t do
        res[i] = _max_width(t[i])
    end
    return res
end

local function ljust(str, num, is_boundary)
    if is_boundary then
        local bars = string.rep("-", num - 2)
        return str:gsub("^(.)%-*(.)$", "%1" .. bars .. "%2")
    else
        return str .. string.rep(" ", num - fn.strwidth(str))
    end
end

M.format = function(line1, line2)
    local first, last = line1, line2

    local tables = api.nvim_buf_get_lines(0, first - 1, last, true)
    local tbl_list = {}
    for i = 1, #tables do
        tbl_list[i] = {}
        for j in vim.gsplit(tables[i], sep) do
            if j ~= "" then
                table.insert(tbl_list[i], trim(j))
            end
        end
    end

    local col_width = max_col_width(tbl_list)

    local formatted = {}
    for i = 1, #tbl_list do
        local temp = {}
        for j = 1, #tbl_list[i] do
            temp[j] = " " .. ljust(tbl_list[i][j], col_width[j], i == 2) .. " "
        end
        formatted[i] = sep .. table.concat(temp, sep) .. sep
    end

    api.nvim_buf_set_lines(0, first - 1, last, true, formatted)
end

M.mapping = function()
    map("i", "<tab>", function(fallback)
        if fn.getline("."):match(sep) then
            M.jump(1)
        else
            fallback()
        end
    end, "buffer")

    map("i", "<S-tab>", function(fallback)
        if fn.getline("."):match(sep) then
            M.jump(-1)
        else
            fallback()
        end
    end, "buffer")
end

M.setup = function()
    command({ "-nargs=*", "TableMake", M.make })
    command({ "-range", "TableFormat", 'lua require("myplug.table").format(<line1>, <line2>)' })
    M.mapping()
    augroup({
        table = {
            {
                "FileType",
                "markdown",
                M.mapping,
            },
        },
    })
end

return M
