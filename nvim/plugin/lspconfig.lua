local status, lspconfig = pcall(require, "lspconfig")
if not status then
    return
end

local status, setup = pcall(require, "cmoscofian.lsp.setup")
if not status then
    return
end

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
