require("lspsaga").init_lsp_saga({
    diagnostic_header = { " ", " ", " ", " " },
    code_action_lightbulb = {
        enable = true,
        enable_in_insert = false,
        sign = false,
        virtual_text = true,
    },
})
