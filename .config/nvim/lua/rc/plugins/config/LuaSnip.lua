local ls = require("luasnip")

local map = Keymap.set

map("is", "<C-j>", function()
    ls.jump(1)
end, "r")
map("is", "<C-k>", function()
    ls.jump(-1)
end, "r")

require("luasnip.loaders.from_snipmate").lazy_load({
    paths = vim.fn.stdpath("config") .. "/snippets",
})

require("rc.plugins.config.LuaSnip.help")
require("rc.plugins.config.LuaSnip.text")

-- ChoiceNode popup
local current_nsid = vim.api.nvim_create_namespace("LuaSnipChoiceListSelections")
local current_win = nil

local function window_for_choiceNode(choiceNode)
    local buf = vim.api.nvim_create_buf(false, true)
    local buf_text = {}
    local row_selection = 0
    local row_offset = 0
    local text
    for _, node in ipairs(choiceNode.choices) do
        text = node:get_docstring()
        -- find one that is currently showing
        if node == choiceNode.active_choice then
            -- current line is starter from buffer list which is length usually
            row_selection = #buf_text
            -- finding how many lines total within a choice selection
            row_offset = #text
        end
        vim.list_extend(buf_text, text)
    end

    vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_text)
    local w, h = vim.lsp.util._make_floating_popup_size(buf_text, {})

    -- adding highlight so we can see which one is been selected.
    local extmark = vim.api.nvim_buf_set_extmark(
        buf,
        current_nsid,
        row_selection,
        0,
        { hl_group = "incsearch", end_line = row_selection + row_offset }
    )

    -- shows window at a beginning of choiceNode.
    local win = vim.api.nvim_open_win(buf, false, {
        relative = "win",
        width = w,
        height = h,
        bufpos = choiceNode.mark:pos_begin_end(),
        style = "minimal",
        border = "rounded",
    })

    -- return with 3 main important so we can use them again
    return { win_id = win, extmark = extmark, buf = buf }
end

local function choice_popup(choiceNode)
    -- build stack for nested choiceNodes.
    if current_win then
        vim.api.nvim_win_close(current_win.win_id, true)
        vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
    end
    local create_win = window_for_choiceNode(choiceNode)
    current_win = {
        win_id = create_win.win_id,
        prev = current_win,
        node = choiceNode,
        extmark = create_win.extmark,
        buf = create_win.buf,
    }
end

local function update_choice_popup(choiceNode)
    vim.api.nvim_win_close(current_win.win_id, true)
    vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
    local create_win = window_for_choiceNode(choiceNode)
    current_win.win_id = create_win.win_id
    current_win.extmark = create_win.extmark
    current_win.buf = create_win.buf
end

local function choice_popup_close()
    vim.api.nvim_win_close(current_win.win_id, true)
    vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
    -- now we are checking if we still have previous choice we were in after exit nested choice
    current_win = current_win.prev
    if current_win then
        -- reopen window further down in the stack.
        local create_win = window_for_choiceNode(current_win.node)
        current_win.win_id = create_win.win_id
        current_win.extmark = create_win.extmark
        current_win.buf = create_win.buf
    end
end

local group_name = "choice_popup"
vim.api.nvim_create_augroup(group_name, {})
vim.api.nvim_create_autocmd("User", {
    pattern = "LuasnipChoiceNodeEnter",
    callback = function()
        choice_popup(ls.session.event_node)
    end,
})
vim.api.nvim_create_autocmd("User", {
    pattern = "LuasnipChoiceNodeLeave",
    callback = function()
        choice_popup_close()
    end,
})
vim.api.nvim_create_autocmd("User", {
    pattern = "LuasnipChangeChoice",
    callback = function()
        update_choice_popup(ls.session.event_node)
    end,
})
