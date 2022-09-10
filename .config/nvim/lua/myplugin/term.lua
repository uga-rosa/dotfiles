local fn = vim.fn
local api = vim.api

local M = {}

local termname = "nvim_terminal"

function M.open(buf)
    if buf > 0 then
        vim.cmd("botright 15sp")
        vim.cmd("buffer " .. termname)
        vim.cmd("startinsert")
    else
        vim.cmd("botright 15sp")
        vim.cmd("terminal")
        vim.cmd("startinsert")
        api.nvim_buf_set_name(0, termname)
        vim.opt_local.buflisted = false
    end
end

function M.close(pane)
    vim.cmd(pane .. "wincmd c")
end

function M.toggle()
    local pane = fn.bufwinnr(termname)
    local buf = fn.bufexists(termname)
    if pane > 0 then
        M.close(pane)
    else
        M.open(buf)
    end
end

local map = Keymap.set

map("nt", "<C-t>", M.toggle)
map("t", "<Esc>", "<C-\\><C-n>")
