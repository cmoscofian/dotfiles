local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>Telescope git_files<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>Telescope buffers<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>G", "<cmd>Telescope live_grep<cr>", opts)
