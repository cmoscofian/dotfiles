local treesitter = require("nvim-treesitter.configs")

treesitter.setup {
	auto_install = false,
	ensure_installed = {
		"bash",
		"cpp",
		"css",
		"go",
		"html",
		"java",
		"javascript",
		"json",
		"markdown",
		"python",
		"rust",
		"typescript",
		"tsx",
		"vim",
	},
	highlight = {
		enable = true,
	},
	ignore_install = {},
	modules = {},
	sync_install = true,
}
