local status, cmp = pcall(require, "cmp")
if not status then
	return
end

cmp.setup {
	mapping = {
		["<enter>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		},
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer", keyword_length = 5 },
	},
	experimental = {
		native_menu = false,
		ghost_text = true,
	},
}
