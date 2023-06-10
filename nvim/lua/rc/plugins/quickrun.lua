local function run_under_cursor_block()
  local context = vim.fn["context_filetype#get"]()
  if context.filetype ~= vim.bo.filetype then
    vim.fn["quickrun#run"]({
      type = context.filetype,
      region = {
        first = { context.range[1][1], 0, 0 },
        last = { context.range[2][1], 0, 0 },
        wise = "V",
      },
    })
  end
end

---@type LazySpec
local spec = {
  {
    "thinca/vim-quickrun",
    dependencies = {
      "lambdalisue/vim-quickrun-neovim-job",
      "Shougo/context_filetype.vim",
    },
    init = function()
      vim.keymap.set("n", "@r", "<Cmd>QuickRun<CR>")

      vim.g.quickrun_config = {
        _ = {
          runner = "neovim_job",
          outputter = "error",
          ["outputter/error/success"] = "buffer",
          ["outputter/error/error"] = "quickfix",
          ["outputter/buffer/opener"] = "botright 10sp",
          ["outputter/buffer/close_on_empty"] = true,
        },
        typescript = {
          command = "deno",
          exec = "%C run -A %S",
        },
        lua = {
          command = "nvim",
          tempfile = "%{tempname()}.lua",
          exec = [[%c --clean --headless -c 'source %s' -c 'cquit 0']],
        },
      }
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.keymap.set("n", "@r", run_under_cursor_block, { buffer = true })
        end,
      })
    end,
  },
}

return spec
