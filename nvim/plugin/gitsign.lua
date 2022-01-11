local status, gitsigns = pcall(require, "gitsigns")
if not status then
    return
end

gitsigns.setup {
    preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
    },
}

