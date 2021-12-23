local f = vim.fn

local theme = {
    bg = "#1d3b53",
    dark_blue = "#092236",
    cadet_blue = "#a1aab8",
    white_blue = "#d6deeb",
    yellow = "#e3d18a",
    peach = "#ffcb8b",
    tan = "#ecc48d",
    orange = "#f78c6c",
    red = "#fc514e",
    watermelon = "#ff5874",
    violet = "#c792ea",
    purple = "#ae81ff",
    indigo = "#5e97ec",
    blue = "#82aaff",
    turquoise = "#7fdbca",
    emerald = "#21c7a8",
    green = "#a1cd5e",
}

local vi_mode_colors = {
    NORMAL = "indigo",
    OP = "indigo",
    INSERT = "white_blue",
    VISUAL = "purple",
    BLOCK = "purple",
    REPLACE = "watermelon",
    ["V-REPLACE"] = "watermelon",
    ENTER = "yellow",
    MORE = "yellow",
    SELECT = "watermelon",
    COMMAND = "emerald",
    SHELL = "emerald",
    TERM = "emerald",
    NONE = "yellow",
}

local icons = {
    diagnostic = {
        error = "  ",
        warn = "  ",
        hint = "  ",
        info = "  ",
    },
    diff = {
        added = " ",
        changed = " ",
        removed = " ",
    },
}

local vi_mode = require("feline.providers.vi_mode")
local git = require("feline.providers.git")
local devicons = require("nvim-web-devicons")

local comps = {
    vi_mode = {
        provider = function()
            local mode = vi_mode.get_vim_mode()
            return "  " .. mode .. " "
        end,
        hl = function()
            return {
                fg = "dark_blue",
                bg = vi_mode.get_mode_color(),
            }
        end,
        right_sep = " ",
    },
    file = {
        name = {
            provider = function()
                return f.expand("%:t")
            end,
            hl = {
                fg = "purple",
                style = "bold",
            },
        },
        icon = {
            provider = function()
                local icon, _ = devicons.get_icon(f.expand("%:t"))
                return icon or ""
            end,
            hl = function()
                local _, cc = devicons.get_icon_color(f.expand("%:t"))
                return {
                    fg = cc,
                }
            end,
            right_sep = " ",
        },
        fullpath = {
            provider = function()
                return f.expand("%:p")
            end,
            hl = {
                fg = "emerald",
            },
        },
    },
    lsp = {
        servers = {
            provider = "lsp_client_names",
            icon = "  ",
            hl = {
                fg = "emerald",
            },
        },
        error = {
            provider = "diagnostic_errors",
            icon = icons.diagnostic.error,
            hl = {
                fg = "red",
            },
        },
        warn = {
            provider = "diagnostic_warnings",
            icon = icons.diagnostic.warn,
            hl = {
                fg = "yellow",
            },
        },
        hint = {
            provider = "diagnostic_hints",
            icon = icons.diagnostic.hint,
            hl = {
                fg = "white_blue",
            },
        },
        info = {
            provider = "diagnostic_info",
            icon = icons.diagnostic.info,
            hl = {
                fg = "blue",
            },
        },
    },
    git = {
        branch = {
            provider = function()
                local head, icon = git.git_branch(0)
                return icon .. head
            end,
            enabled = function()
                return git.git_branch(0) ~= ""
            end,
            hl = {
                fg = "purple",
            },
        },
        diff = {
            add = {
                provider = function()
                    return git.git_diff_added(0)
                end,
                icon = icons.diff.added,
                enabled = function()
                    return git.git_diff_added(0) ~= ""
                end,
                hl = {
                    fg = "green",
                },
                left_sep = " ",
            },
            change = {
                provider = function()
                    return git.git_diff_changed(0)
                end,
                icon = icons.diff.changed,
                enabled = function()
                    return git.git_diff_changed(0) ~= ""
                end,
                hl = {
                    fg = "yellow",
                },
                left_sep = " ",
            },
            remove = {
                provider = function()
                    return git.git_diff_removed(0)
                end,
                icon = icons.diff.removed,
                enabled = function()
                    return git.git_diff_removed(0) ~= ""
                end,
                hl = {
                    fg = "red",
                },
                left_sep = " ",
            },
        },
    },
    cursor = {
        pos_per = {
            provider = function()
                local c = require("feline.providers.cursor")
                return " " .. c.position(nil, {}) .. " " .. c.line_percentage() .. " "
            end,
            hl = {
                fg = "bg",
                bg = "emerald",
            },
            left_sep = " ",
        },
        bar = {
            provider = "scroll_bar",
            hl = {
                fg = "emerald",
            },
        },
    },
}

local components = {
    active = { {}, {}, {} },
    inactive = { {}, {}, {} },
}

function components.active_add(self, n, x)
    table.insert(self.active[n], x)
end

function components.inactive_add(self, n, x)
    table.insert(self.inactive[n], x)
end

components:active_add(1, comps.vi_mode)
components:active_add(1, comps.file.icon)
components:active_add(1, comps.file.name)
components:active_add(1, comps.lsp.error)
components:active_add(1, comps.lsp.warn)
components:active_add(1, comps.lsp.hint)
components:active_add(1, comps.lsp.info)
components:active_add(2, comps.git.branch)
components:active_add(2, comps.git.diff.add)
components:active_add(2, comps.git.diff.change)
components:active_add(2, comps.git.diff.remove)
components:active_add(3, comps.lsp.servers)
components:active_add(3, comps.cursor.pos_per)
components:active_add(3, comps.cursor.bar)
components:inactive_add(1, comps.file.fullpath)

require("feline").setup({
    vi_mode_colors = vi_mode_colors,
    components = components,
    force_inactive = {
        filetypes = {
            "filittle",
            "quickrun",
        },
    },
})

require("feline").use_theme(theme)
