local cmp = require("cmp")
local types = require("cmp.types")
local luasnip = require("luasnip")

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<c-k>"] = cmp.mapping.select_prev_item(),
		["<c-j>"] = cmp.mapping.select_next_item(),
		["<c-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<cr>"] = cmp.mapping.confirm { select = true },
		["<tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s", }),
		["<s-tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s", }),
	},
	sources = {
		{
			name = "nvim_lsp",
			entry_filter = function(entry, _)
				return entry:get_kind() ~= types.lsp.CompletionItemKind.Snippet
			end,
		},
	},
	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = function(entry, item)
			item.kind = string.format("%s", item.kind)
			item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
			})[entry.source.name]
			return item
		end,
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	experimental = {
		native_menu = false,
		ghost_text = true,
	},
}
