local telescope = require("telescope")
local utils = require("telescope.utils")
local actions = require("telescope.actions")
local handlers = require("telescope.builtin")

telescope.setup {
    defaults = {
        initial_mode = "normal",
        path_display = function(_, path)
            local tail = utils.path_tail(path)
            return string.format("%s (%s)", tail, path)
        end,
        prompt_prefix = "? ",
        selection_caret = "▹ ",
        file_ignore_patterns = {
            "node_modules/",
            "target/",
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

local opts = { silent = true }
vim.keymap.set("n", "<leader>b", handlers.buffers, opts)
vim.keymap.set("n", "<leader>c", handlers.git_commits, opts)
vim.keymap.set("n", "<leader>f", handlers.find_files, opts)
vim.keymap.set("n", "<leader>g", handlers.live_grep, opts)
vim.keymap.set("n", "<leader>h", handlers.help_tags, opts)
vim.keymap.set("n", "<leader>q", handlers.quickfix, opts)
vim.keymap.set("n", "<leader>s", handlers.git_status, opts)
vim.keymap.set("n", "<leader>de", function() handlers.diagnostics({ severity = "error" }) end, opts)
vim.keymap.set("n", "<leader>dw", function() handlers.diagnostics({ severity = "warn" }) end, opts)
vim.keymap.set("n", "<leader>di", function() handlers.diagnostics({ severity = "info" }) end, opts)
vim.keymap.set("n", "<leader>dh", function() handlers.diagnostics({ severity = "hint" }) end, opts)
