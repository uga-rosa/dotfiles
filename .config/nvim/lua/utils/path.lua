-- For public function
local Path = {}

local uv = vim.loop
local mode = tonumber("0666", 8)

---Read file synchronously.
---@param p string #Path
---@return string #The contents of the p
function Path.readfile(p)
    local fd = assert(uv.fs_open(p, "r", mode))
    local stat = assert(uv.fs_fstat(fd))
    local buf = assert(uv.fs_read(fd, stat.size, 0))
    assert(uv.fs_close(fd))
    return buf
end

---An iterator that returns the contents of a file line by line.
---This function can be used in a for statement.
---
---for line in Path.line("/path/to/file") do
---    print(line)
---end
---
---@param p string #Path
---@return function
function Path.lines(p)
    local buf = Path.readfile(p)
    local lines = vim.split(buf or "", "\n")
    local i = 0
    return function()
        i = i + 1
        return lines[i]
    end
end

---Get current working directory.
---@return string
function Path.getcwd()
    return uv.cwd()
end

-- For method
---@class path
local path = setmetatable({}, { __index = Path })

---Create a new instance of path.
---@param ... string
---@return path
function Path.new(...)
    local paths = { ... }
    if #paths == 0 then
        assert(false, "Need args at least 1.")
    end
    local top = paths[1]
    if not top:find("^/") then
        -- relative path
        -- add cuurent working directory
        table.insert(paths, 1, Path.getcwd())
    end

    local result = {
        path = paths[1],
        cwd = Path.getcwd(),
    }
    setmetatable(result, { __index = path })

    if #paths > 1 then
        table.remove(paths, 1)
        result:join(paths)
    end
    return result
end

---Whether the path exists.
---@return boolean
function path:exists()
    return uv.fs_open(self, "r", mode) ~= nil
end

return Path
