local lspconfig = require("lspconfig")
local setup = require("cmoscofian.lsp.setup")

lspconfig.clangd.setup {
    capabilities = setup.capabilities,
    on_attach = setup.on_attach,
    single_file_support = true,
}

lspconfig.gopls.setup {
    capabilities = setup.capabilities,
    on_attach = setup.on_attach,
    cmd = {"gopls", "serve"},
    settings = {
        gopls = {
            analyses = {
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
    capabilities = setup.capabilities,
    on_attach = setup.on_attach,
    single_file_support = true,
    init_options = {
        preferences = {
            includeCompletionsWithSnippetText = true,
            includeCompletionsForImportStatements = true,
        },
    },
}

lspconfig.jsonls.setup {
    capabilities = setup.capabilities,
    on_attach = setup.on_attach,
    single_file_support = true,
}

lspconfig.sumneko_lua.setup {
    capabilities = setup.capabilities,
    on_attach = setup.on_attach,
    cmd = {"lua-language-server"},
    settings = {
        Lua = {
            completion = {
                keywordSnippet = "Disable",
            },
            diagnostics = {
                globals = {"vim", "use"},
                disable = {"lowercase-global"}
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
