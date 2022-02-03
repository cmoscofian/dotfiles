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


local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "[c", "<cmd>Gitsigns prev_hunk<cr>", opts)
vim.api.nvim_set_keymap("n", "]c", "<cmd>Gitsigns next_hunk<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>ph", "<cmd>Gitsigns preview_hunk<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>rh", "<cmd>Gitsigns reset_hunk<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>rb", "<cmd>Gitsigns reset_buffer<cr>", opts)
