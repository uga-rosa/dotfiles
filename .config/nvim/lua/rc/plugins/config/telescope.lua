local telescope = require("telescope")

telescope.setup({
    pickers = {
        find_files = {
            find_command = { "fd", "-E", ".git", "-t", "f" },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
})
telescope.load_extension("fzf")
telescope.load_extension("frecency")
telescope.load_extension("ui-select")
