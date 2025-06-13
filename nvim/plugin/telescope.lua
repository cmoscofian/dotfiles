local telescope = require("telescope")
local utils = require("telescope.utils")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

telescope.setup {
	defaults = {
		initial_mode = "normal",
		path_display = function(_, path)
			local tail = utils.path_tail(path)
			return string.format("%s (%s)", tail, path)
		end,
		file_ignore_patterns = {
			"^%.git/",
			"^node_modules/",
			"^target/",
			"^build/",
			"%.lock",
		},
		mappings = {
			i = {
				["<c-j>"] = actions.move_selection_next,
				["<c-k>"] = actions.move_selection_previous,
				["<c-a>"] = actions.send_selected_to_qflist + actions.open_qflist,
			},
			n = {
				["<c-a>"] = actions.send_selected_to_qflist + actions.open_qflist,
			},
		},
		prompt_prefix = "> ",
		selection_caret = "▷ ",
	},
	pickers = {
		find_files = {
			initial_mode = "insert",
			hidden = true,
		},
		live_grep = {
			initial_mode = "insert",
			hidden = true,
		},
		help_tags = {
			initial_mode = "insert",
		},
	},
}

local opts = { silent = true }
vim.keymap.set("n", "<leader>b", builtin.buffers, opts)
vim.keymap.set("n", "<leader>c", builtin.git_commits, opts)
vim.keymap.set("n", "<leader>f", builtin.find_files, opts)
vim.keymap.set("n", "<leader>g", builtin.live_grep, opts)
vim.keymap.set("n", "<leader>G", builtin.grep_string, opts)
vim.keymap.set("n", "<leader>h", builtin.help_tags, opts)
vim.keymap.set("n", "<leader>q", builtin.quickfix, opts)
vim.keymap.set("n", "<leader>s", builtin.git_status, opts)
vim.keymap.set("n", "<leader>de", function() builtin.diagnostics({ severity = "error" }) end, opts)
vim.keymap.set("n", "<leader>dw", function() builtin.diagnostics({ severity = "warn" }) end, opts)
vim.keymap.set("n", "<leader>di", function() builtin.diagnostics({ severity = "info" }) end, opts)
vim.keymap.set("n", "<leader>dh", function() builtin.diagnostics({ severity = "hint" }) end, opts)
