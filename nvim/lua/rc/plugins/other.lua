---@type LazySpec
local spec = {
  { "thinca/vim-themis" },
  {
    "uga-rosa/contextment.vim",
    dependencies = "Shougo/context_filetype.vim",
    keys = {
      { "gc", "<Plug>(contextment)", mode = { "n", "x", "o" } },
      { "gcc", "<Plug>(contextment-line)", mode = "n" },
    },
  },
  {
    "tyru/capture.vim",
    cmd = "Capture",
    init = function()
      vim.keymap.set("c", "<C-c>", function()
        if vim.fn.getcmdtype() == ":" then
          local cmdline = vim.fn.getcmdline()
          vim.fn.histadd(":", cmdline)
          vim.schedule(function()
            vim.cmd("Capture " .. cmdline)
          end)
        end
        return "<C-c>"
      end, { expr = true })
    end,
  },
  {
    "tyru/open-browser.vim",
    keys = {
      { "<M-o>", "<Plug>(openbrowser-smart-search)", mode = { "n", "x" } },
    },
    init = function()
      vim.g.openbrowser_browser_commands = {
        {
          name = "wslview",
          args = { "{browser}", "{uri}" },
        },
      }
    end,
  },
  {
    "simeji/winresizer",
    keys = {
      { "<C-e>", "<Cmd>WinResizerStartResize<CR>", mode = "n" },
    },
  },
  {
    "junegunn/vim-easy-align",
    cmd = "EasyAlign",
  },
  {
    "thinca/vim-partedit",
    cmd = "Partedit",
    config = function()
      vim.g["partedit#prefix_pattern"] = "\\s*"
      vim.g["partedit#auto_prefix"] = 0
    end,
  },
  {
    "uga-rosa/linkformat.vim",
    cmd = "LinkFormatPaste",
    init = function()
      vim.g.linkformat_template = table.concat({ "{", '"<>"', "}" }, "\n")
    end,
  },
  {
    "tweekmonster/helpful.vim",
    cmd = "HelpfulVersion",
  },
  {
    "delphinus/emcl.nvim",
    event = "CmdlineEnter",
    config = function()
      require("emcl").setup({
        enabled = {
          "ForwardChar",
          "BackwardChar",
          "BeginningOfLine",
          "EndOfLine",
          "AbortCommand",
          "ForwardWord",
          "BackwardWord",
          "DeleteChar",
          "BackwardDeleteChar",
          "KillWord",
          "DeleteBackwardsToWhiteSpace",
          "BackwardKillWord",
          "TransposeChar",
          "TransposeWord",
          "ToggleExternalCommand",
        },
      })
    end,
  },
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", "<Plug>(dial-increment)", mode = { "n", "x" } },
      { "<C-x>", "<Plug>(dial-decrement)", mode = { "n", "x" } },
      { "g<C-a>", "g<Plug>(dial-increment)", mode = "x" },
      { "g<C-x>", "g<Plug>(dial-decrement)", mode = "x" },
    },
  },
  {
    "notomo/waitevent.nvim",
    config = function()
      vim.env.GIT_EDITOR = require("waitevent").editor({
        open = function(ctx, path)
          vim.cmd.tabedit(path)
          ctx.tcd()
          vim.bo.bufhidden = "wipe"
        end,
      })

      vim.env.EDITOR = require("waitevent").editor({
        done_events = {},
        cancel_events = {},
      })
    end,
  },
  {
    "ojroques/vim-oscyank",
    keys = {
      { "<Space>c", "<Plug>OSCYankOperator", mode = "n" },
      { "<Space>cc", "<Plug>OSCYankOperator_", mode = "n" },
      { "<Space>c", "<Plug>OSCYankVisual", mode = "x" },
    },
  },
  {
    "uga-rosa/ugaterm.nvim",
    keys = {
      { "<M-t>", "<Cmd>UgatermToggle<CR>", mode = { "n", "t" } },
      { "<M-n>", "<Cmd>UgatermNew<CR><Cmd>UgatermRename<CR>", mode = { "n", "t" } },
    },
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "UgatermEnter",
        group = vim.api.nvim_create_augroup("ugaterm-enter", {}),
        command = "startinsert",
      })
    end,
  },
  {
    -- help doc generator
    "tani/podium",
    config = function()
      local podium = require("podium")
      vim.api.nvim_create_user_command("Podium", function()
        local input = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, true), "\n")
        local processor = podium.PodiumProcessor.new(podium.vimdoc)
        local output = processor:process(input)
        vim.cmd.new()
        vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(output, "\n"))
        vim.api.nvim_set_option_value("modified", false, { buf = 0 })
        vim.api.nvim_set_option_value("filetype", "help", { buf = 0 })
      end, {})
    end,
  },
}

return spec
