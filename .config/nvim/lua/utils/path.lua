local Path = {}

local uv = vim.loop

function Path.readfile(path)
    local fd = uv.fs_open(path, "r", tonumber("0444", 8))
    if fd then
        local stat = uv.fs_stat(fd)
        if stat then
            local buf = uv.fs_read(fd, stat.size, 0)
            if buf then
                return buf
            else
                print("cannot get buffer")
            end
        else
            print("cannot stat")
        end
        uv.fs_close(fd)
    else
        print("cannot open")
    end
end

function Path.lines(path)
    local buf = Path.readfile(path)
    if buf then
        return function()
            for line in vim.gsplit(buf, "\n") do
                return line
            end
        end
    end
end

return Path
