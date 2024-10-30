local lspconfig = require("lspconfig")
local config = require("cmoscofian.lsp").config

lspconfig.clangd.setup {
	capabilities = config.capabilities,
	cmd = { "clangd", "--background-index", "--suggest-missing-includes" },
	filetypes = { "c", "cc", "cpp", "h", "hpp", "objc", "objcpp" },
	on_attach = config.on_attach,
	single_file_support = true,
}

lspconfig.cssls.setup {
	capabilities = config.capabilities,
	on_attach = config.on_attach,
	single_file_support = true,
}

lspconfig.gopls.setup {
	capabilities = config.capabilities,
	cmd = { "gopls", "-rpc.trace", "-logfile=/tmp/gopls", "serve", "--debug=localhost:6060" },
	on_attach = config.on_attach,
	settings = {
		gopls = {
			analyses = {
				fieldalignment = true,
				nilness = true,
				shadow = true,
				unusedparams = true,
				unusedvariables = true,
				unusedwrite = true,
				useany = true,
			},
			staticcheck = true,
			usePlaceholders = true,
		}
	},
	single_file_support = true,
}

lspconfig.html.setup {
	capabilities = config.capabilities,
	on_attach = config.on_attach,
	single_file_support = true,
}

lspconfig.jsonls.setup {
	capabilities = config.capabilities,
	on_attach = config.on_attach,
	single_file_support = true,
}

lspconfig.kotlin_language_server.setup {
	capabilities = config.capabilities,
	on_attach = config.on_attach,
	single_file_support = true,
}

lspconfig.lua_ls.setup {
	capabilities = config.capabilities,
	cmd = { "lua-language-server" },
	on_attach = config.on_attach,
	settings = {
		Lua = {
			completion = {
				keywordSnippet = "Disable",
			},
			diagnostics = {
				globals = { "vim", "use" },
				disable = { "lowercase-global" }
			},
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
			},
		},
	},
	single_file_support = true,
}

lspconfig.pyright.setup {
	capabilities = config.capabilities,
	on_attach = config.on_attach,
	settings = {
		python = {
			disableOrganizeImports = false,
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
			},
		},
	},
	single_file_support = true,
}

lspconfig.rust_analyzer.setup {
	capabilities = config.capabilities,
	cmd = {
		"rust-analyzer",
	},
	on_attach = config.on_attach,
	settings = {
		["rust-analyzer"] = {
			inlayHints = {
				lifetimeElisionHints = {
					enable = true,
					useParameterNames = true
				},
			},
		},
	},
	single_file_support = true,
}

lspconfig.ts_ls.setup {
	capabilities = config.capabilities,
	init_options = {
		preferences = {
			includeCompletionsWithSnippetText = true,
			includeCompletionsForImportStatements = true,
		},
	},
	on_attach = config.on_attach,
	single_file_support = true,
}
