local status, lualine = pcall(require, "lualine")
if not status then
    return
end

lualine.setup {
    options = {
        icons_enabled = true,
        theme = "nord",
        component_separators = { left = "", right = ""},
        section_separators = { left = "", right = ""},
    },
    sections = {
        lualine_c = {
            {
                "filename",
                file_status = true,
                path = 1,
            },
        },
    },
}
