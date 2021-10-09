local map = myutils.map

vim.g.bufferline = {
  auto_hide = true,
  exclude_ft = { "filittle" },
}

map("n", "<A-,>", "BufferPrevious", { "noremap", "cmd" })
map("n", "<A-.>", "BufferNext", { "noremap", "cmd" })
map("n", "<A-<>", "BufferMovePrevious", { "noremap", "cmd" })
map("n", "<A->>", "BufferMoveNext", { "noremap", "cmd" })
map("n", "<A-1>", "BufferGoto 1", { "noremap", "cmd" })
map("n", "<A-2>", "BufferGoto 2", { "noremap", "cmd" })
map("n", "<A-3>", "BufferGoto 3", { "noremap", "cmd" })
map("n", "<A-4>", "BufferGoto 4", { "noremap", "cmd" })
map("n", "<A-5>", "BufferGoto 5", { "noremap", "cmd" })
map("n", "<A-6>", "BufferGoto 6", { "noremap", "cmd" })
map("n", "<A-7>", "BufferGoto 7", { "noremap", "cmd" })
map("n", "<A-8>", "BufferGoto 8", { "noremap", "cmd" })
map("n", "<A-9>", "BufferGoto 9", { "noremap", "cmd" })
map("n", "<A-0>", "BufferGoto 0", { "noremap", "cmd" })
map("n", "<A-c>", "BufferClose", { "noremap", "cmd" })
