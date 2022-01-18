local telescope = require("telescope")
local utils = require("telescope.utils")
local actions = require("telescope.actions")

telescope.setup {
    defaults = {
        initial_mode = "normal",
        path_display = function(_, path)
            local tail = utils.path_tail(path)
            return string.format("%s (%s)", tail, path)
        end,
        prompt_prefix = " ",
        selection_caret = "▹ ",
        file_ignore_patterns = {
            "node_modules/",
        },
        mappings = {
            i = {
                ["<c-n>"] = actions.cycle_history_next,
                ["<c-p>"] = actions.cycle_history_prev,
                ["<c-j>"] = actions.move_selection_next,
                ["<c-k>"] = actions.move_selection_previous,
            },
            n = {
                ["<c-s>"] = actions.select_horizontal,
                ["<c-v>"] = actions.select_vertical,
            },
        },
    },
    pickers = {
        find_files = {
            initial_mode = "insert",
        },
        live_grep = {
            initial_mode = "insert",
        },
        help_tags = {
            initial_mode = "insert",
        },
        lsp_dynamic_workspace_symbols = {
            initial_mode = "insert",
        }
    },
}

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>lua require('telescope.builtin').buffers()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>f", "<cmd>lua require('telescope.builtin').find_files()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua require('telescope.builtin').live_grep()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>h", "<cmd>lua require('telescope.builtin').help_tags()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>lua require('telescope.builtin').quickfix()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>s", "<cmd>lua require('telescope.builtin').git_status()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>de", "<cmd>Telescope diagnostics severity=error<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>dw", "<cmd>Telescope diagnostics severity=warn<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>di", "<cmd>Telescope diagnostics severity=info<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>dh", "<cmd>Telescope diagnostics severity=hint<cr>", opts)
