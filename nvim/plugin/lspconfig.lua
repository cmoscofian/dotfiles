local lspconfig = require("lspconfig")
local config = require("cmoscofian.lsp").config

lspconfig.clangd.setup {
    capabilities = config.capabilities,
    on_attach = config.on_attach,
    cmd = { "clangd", "--background-index", "--suggest-missing-includes" },
    filetypes = { "c", "cc", "cpp", "h", "hpp", "objc", "objcpp" },
    single_file_support = true,
}

lspconfig.gopls.setup {
    capabilities = config.capabilities,
    on_attach = config.on_attach,
    cmd = { "gopls", "serve" },
    settings = {
        gopls = {
            analyses = {
                fieldalignment = true,
                nilness = true,
                shadow = true,
                unusedparams = true,
                unusedwrite = true,
            },
            staticcheck = true,
            usePlaceholders = true,
        }
    },
    single_file_support = true,
}

lspconfig.tsserver.setup {
    capabilities = config.capabilities,
    on_attach = config.on_attach,
    single_file_support = true,
    init_options = {
        preferences = {
            includeCompletionsWithSnippetText = true,
            includeCompletionsForImportStatements = true,
        },
    },
}

lspconfig.lua_ls.setup {
    capabilities = config.capabilities,
    on_attach = config.on_attach,
    cmd = { "lua-language-server" },
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
}

lspconfig.cssls.setup {
    capabilities = config.capabilities,
    on_attach = config.on_attach,
}

lspconfig.html.setup {
    capabilities = config.capabilities,
    on_attach = config.on_attach,
}

lspconfig.jsonls.setup {
    capabilities = config.capabilities,
    on_attach = config.on_attach,
}

lspconfig.rust_analyzer.setup {
    capabilities = config.capabilities,
    on_attach = config.on_attach,
    single_file_support = true,
    cmd = {
        "rust-analyzer",
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
}

lspconfig.pyright.setup {
    capabilities = config.capabilities,
    on_attach = config.on_attach,
    single_file_support = true,
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
}
