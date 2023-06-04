local lualine = require("lualine")

lualine.setup {
    options = {
        icons_enabled = true,
        -- This hack depends on creating a new theme called "nibble" inside the
        -- lualine themes folder.
        theme = "nibble",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "java" },
    },
    sections = {
        lualine_b = {
            { "branch" },
            { "diff" },
            {
                "diagnostics",
                symbols = {
                    error = "e:",
                    warn = "w:",
                    info = "i:",
                    hint = "h:"
                },
            },
        },
        lualine_c = {
            {
                "filename",
                path = 1,
                symbols = {
                    readonly = "[RO]",
                    unnamed = "[NO NAME]",
                },
            },
        },
        lualine_x = {
            { "filetype", colored = false, padding = 3 },
        },
    },
}
