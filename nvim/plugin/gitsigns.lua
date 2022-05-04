local gitsigns = require("gitsigns")

gitsigns.setup {
    preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
    },
}


local opts = { silent = true }
vim.keymap.set("n", "[c", gitsigns.prev_hunk, opts)
vim.keymap.set("n", "]c", gitsigns.next_hunk, opts)
vim.keymap.set("n", "<leader>ph", gitsigns.preview_hunk, opts)
vim.keymap.set("n", "<leader>rh", gitsigns.reset_hunk, opts)
vim.keymap.set("n", "<leader>rb", gitsigns.reset_buffer, opts)
