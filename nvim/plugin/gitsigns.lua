local gitsigns = require("gitsigns")

gitsigns.setup {
	signs = {
		add          = { text = '+' },
		change       = { text = '~' },
	},
	signs_staged = {
		add          = { text = '+' },
		change       = { text = '~' },
	},
	current_line_blame = false,
	current_line_blame_opts = {
		delay = 2000,
		ignore_whitespace = false,
		virt_text = true,
		virt_text_pos = "right_align",
	},
	preview_config = {
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
}


local opts = { silent = true }
vim.keymap.set("n", "[^", function() gitsigns.nav_hunk("first") end, opts)
vim.keymap.set("n", "[c", function() gitsigns.nav_hunk("prev") end, opts)
vim.keymap.set("n", "]c", function() gitsigns.nav_hunk("next") end, opts)
vim.keymap.set("n", "]$", function() gitsigns.nav_hunk("last") end, opts)
vim.keymap.set("n", "<leader>ph", gitsigns.preview_hunk, opts)
vim.keymap.set("n", "<leader>rh", gitsigns.reset_hunk, opts)
vim.keymap.set("n", "<leader>rb", gitsigns.reset_buffer, opts)
