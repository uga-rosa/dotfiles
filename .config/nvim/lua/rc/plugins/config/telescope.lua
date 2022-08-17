require("telescope").setup({
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
require("telescope").load_extension("fzf")
require("telescope").load_extension("frecency")
