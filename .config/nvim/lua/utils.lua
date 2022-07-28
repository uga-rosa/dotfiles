local uv = vim.loop

---Transforms ctx into a human readable representation.
---@vararg any
function _G.dump(...)
    for _, ctx in ipairs({ ... }) do
        print(vim.inspect(ctx))
    end
end

function _G.readfile(path)
    local fd = assert(uv.fs_open(path, "r", tonumber("0444", 8)))
    local stat = assert(uv.fs_stat(fd))
    local buf = assert(uv.fs_read(fd, stat.size, 0))
    uv.fs_close(fd)
    return buf
end
