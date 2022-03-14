local M = {}

---@type table<number, boolean>
---Keys are id, values are whether it is attached or not
local attached = {}

function M.check_server()
    for _, server in ipairs(vim.lsp.get_active_clients()) do
        local id = server.id
        local filetypes = server.config.filetypes or {}
        if vim.tbl_contains(filetypes, vim.bo.filetype) then
            vim.lsp.buf_attach_client(0, id)
            attached[id] = true
        elseif attached[id] then
            vim.lsp.buf_detach_client(0, id)
            attached[id] = nil
        end
    end
end

return M
