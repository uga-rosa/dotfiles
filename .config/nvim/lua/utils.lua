---Transforms ctx into a human readable representation.
---@vararg any
function _G.dump(...)
    for _, ctx in ipairs({ ... }) do
        print(vim.inspect(ctx))
    end
end
