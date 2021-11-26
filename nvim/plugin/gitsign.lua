local status, gitsigns = pcall(require, "gitsigns")
if not status then
    return
end

gitsigns.setup {
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'right_align',
        delay = 500,
        ignore_whitespace = false,
    },
    current_line_blame_formatter_opts = {
        relative_time = false
    },
}

