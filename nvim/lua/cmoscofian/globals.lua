vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Briefly highlight text when yanking",
	group = vim.api.nvim_create_augroup("YankedGroup", { clear = true }),
	callback = function()
		vim.hl.on_yank({ on_visual = false })
	end,
})
