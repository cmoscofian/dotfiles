local config = require("cmoscofian.lsp").config

vim.lsp.config("*", {
	capabilities = config.capabilities,
	root_markers = { ".git" },
	single_file_support = true,
})

vim.lsp.config("c", {
	cmd = { "clangd", "--background-index", "--suggest-missing-includes" },
	filetypes = { "c", "cc", "cpp", "h", "hpp", "objc", "objcpp" },
	root_markers = {
		".clangd",
		".clang-tidy",
		".clang-format",
		"compile_commands.json",
		"compile_flags.txt",
		"configure.ac",
		".git",
	},
	capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { "utf-8", "utf-16" },
	},
})

vim.lsp.config("css", {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	init_options = { provideFormatter = true },
	root_markers = {
		"package.json",
		".git",
	},
	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
})

vim.lsp.config("go", {
	cmd = { "gopls", "-rpc.trace", "-logfile=/tmp/gopls", "serve", "--debug=localhost:6060" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = {
		"go.work",
		"go.mod",
		".git",
	},
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
})

vim.lsp.config("html", {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "templ" },
	root_markers = { "package.json", ".git" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = { css = true, javascript = true },
		provideFormatter = true,
	},
})

vim.lsp.config("json", {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	init_options = {
		provideFormatter = true,
	},
	root_markers = { ".git" },
})

vim.lsp.config("kotlin", {
	filetypes = { "kotlin" },
	root_markers = {
		"settings.gradle",
		"settings.gradle.kts",
		"build.xml",
		"pom.xml",
		"build.gradle",
		"build.gradle.kts",
	},
	cmd = { "kotlin-language-server" },
})

vim.lsp.config("lua", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
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
})

vim.lsp.config("python", {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	},
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
})

vim.lsp.config("rust", {
	cmd = { "rust-analyzer", },
	filetypes = { "rust" },
	capabilities = {
		experimental = {
			serverStatusNotification = true,
		},
	},
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
})

vim.lsp.config("typescript", {
	cmd = { "typescript-language-server", "--stdio" },
	init_options = {
		preferences = {
			includeCompletionsWithSnippetText = true,
			includeCompletionsForImportStatements = true,
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_markers = {
		"tsconfig.json",
		"jsconfig.json",
		"package.json",
		".git",
	},
	handlers = {
		-- handle rename request for certain code actions like extracting functions / types
		["_typescript.rename"] = function(_, result, ctx)
			local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
			vim.lsp.util.show_document({
				uri = result.textDocument.uri,
				range = {
					start = result.position,
					["end"] = result.position,
				},
			}, client.offset_encoding)
			vim.lsp.buf.rename()
			return vim.NIL
		end,
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspAttachGroup", {}),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		config.on_attach(client, args.buf)
	end,
})

vim.lsp.enable({
	"c",
	"css",
	"go",
	"html",
	"json",
	"kotlin",
	"lua",
	"python",
	"rust",
	"typescript",
})
