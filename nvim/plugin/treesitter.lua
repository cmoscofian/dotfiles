local treesitter = require("nvim-treesitter")

treesitter.install({
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
	"tsx",
	"typescript",
	"vim",
	"yaml",
})
treesitter.setup()

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"bash",
		"c",
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
		"tsx",
		"typescript",
		"vim",
		"yaml",
	},
	callback = function()
		vim.treesitter.start()
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
