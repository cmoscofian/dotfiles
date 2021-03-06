local lualine = require("lualine")

lualine.setup {
    options = {
        icons_enabled = true,
        -- This hack depends on creating a new theme called "nibble" inside the
        -- lualine themes folder.
        theme = "nibble",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
    },
    sections = {
        lualine_b = {
            { "branch", padding = 2 },
            { "diff", padding = 2 },
            { "diagnostics", padding = 1 },
        },
        lualine_c = {
            {
                "filename",
                path = 1,
                symbols= {
                    readonly = "[RO]",
                    unnamed = "[NO NAME]",
                },
            },
        },
        lualine_x = {
            {
                "filetype",
                colored = false,
                padding = 3,
            },
        },
    },
}
