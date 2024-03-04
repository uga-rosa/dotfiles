---@type PluginSpec
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
    setup = function()
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
    "uga-rosa/ugaterm.nvim",
    dev = true,
    init = function()
      vim.keymap.set({ "n", "t" }, "<M-t>", "<Cmd>UgatermOpen -toggle<CR>")
    end,
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "UgatermEnter",
        group = vim.api.nvim_create_augroup("ugaterm-enter", {}),
        command = "startinsert",
      })
    end,
  },
  {
    "kawarimidoll/autoplay.vim",
  },
  {
    "uga-rosa/estrela.lua",
    dev = true,
  },
  {
    "hrsh7th/nvim-kit",
  },
}

return spec
