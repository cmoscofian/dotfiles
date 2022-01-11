local telescope = require("telescope")
local utils = require("telescope.utils")
local actions = require("telescope.actions")

telescope.setup {
    defaults = {
        path_display = function(_, path)
            local tail = utils.path_tail(path)
            return string.format("%s (%s)", tail, path)
        end,
        prompt_prefix = " ",
        selection_caret = "▹ ",
        file_ignore_patterns = {
            "node_modules/",
            "test/",
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
        lsp_code_actions = {
            initial_mode = "normal",
        },
        lsp_references = {
            initial_mode = "normal",
        },
        lsp_implementations = {
            initial_mode = "normal",
        },
        buffers = {
            initial_mode = "normal",
        },
        quickfix = {
            initial_mode = "normal",
        },
    },
}

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>Telescope git_files<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>G", "<cmd>Telescope live_grep<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>h", "<cmd>Telescope help_tags<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>Telescope buffers<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>Telescope quickfix<cr>", opts)

